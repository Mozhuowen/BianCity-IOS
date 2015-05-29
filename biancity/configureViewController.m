//
//  configureViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/19.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "configureViewController.h"
#import "settingTableViewCell.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "UMUUploaderManager.h"
#import "SDProgressView.h"
#import "SDDemoItemView.h"
#import "UIView+KeyboardObserver.h"
#import <CommonCrypto/CommonDigest.h>
#import "ResponseSimple.h"
#import "ResponseLogin.h"
#import "ResponseRegiste.h"
#import "PopView.h"
@interface configureViewController (){
    NSInteger index_com;
    BOOL isChange;
}
@property (nonatomic,strong) UITableView* configureTableView;
@property (nonatomic,strong) NSMutableArray *section;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) SDDemoItemView *progress;
@property (nonatomic,strong) UITextField * responseText;
@property (nonatomic,strong) UILabel * retrunLabel;
@property (nonatomic,strong) UIView *bgTextView;
@property (nonatomic,strong) ResponseSimple* response;

@property (nonatomic,strong) ResponseRegiste* registe;
@property (nonatomic,strong) ResponseLogin *login;
@end

@implementation configureViewController

-(void)viewWillAppear:(BOOL)animated{
    [_bgTextView addKeyboardObserver];
    [self readUserDeafultsOwn];
    [self.configureTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_bgTextView removeKeyboardObserver];
}
- (void) readUserDeafultsOwn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache;
    cache = [userDefaults dictionaryForKey:LOGIN_INFO];
    if([(NSNumber*)[cache objectForKey:@"needregiste"] boolValue]){
        cache = [userDefaults dictionaryForKey:REGISTE_INFO];
        _registe =[[ResponseRegiste alloc] initWithDictionary:cache error:nil];
    
        _user.cover = _registe.cover;
        _user.name = _registe.name;
        _user.sex = _registe.sex;
        _user.location = _registe.location;
            return;
        
    }
    _login=[[ResponseLogin alloc] initWithDictionary:cache error:nil];
    
    _user.cover = _login.cover;
    _user.name = _login.name;
    _user.sex = _login.sex;
    _user.location = _login.location;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    _user = [[ModelUser alloc] init];
    _user.onlystatis = YES;
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    CGRect rc  = [UIScreen mainScreen].bounds;
    rc.origin.y +=20;
    
    _configureTableView = [[UITableView alloc] initWithFrame:rc style:UITableViewStyleGrouped];
    _configureTableView.delegate =self;
    _configureTableView.dataSource =self;
  [self.configureTableView registerClass:[settingTableViewCell class] forCellReuseIdentifier:@"settingTableViewCell"];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
//    self.navigationItem.leftBarButtonItem = leftButton;
//    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(selectRightAction:)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectLeftAction:)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"ic_note_complete_normal"]
                           forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(selectRightAction:)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *rightmenuButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem =rightmenuButton;
    
    
    
 _section = [[NSMutableArray alloc] initWithObjects:@"点击修改头像",@"昵称",@"性别",@"所在地", nil];
    _bgTextView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
    _bgTextView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _responseText = [[UITextField alloc] initWithFrame:CGRectMake(5, 4, _bgTextView.frame.size.width-80, _bgTextView.frame.size.height-8)];
    _responseText.layer.borderWidth =1.0;
    _responseText.layer.cornerRadius =3.0;
    _responseText.backgroundColor =[UIColor whiteColor];
    _responseText.layer.borderColor = [[UIColor grayColor] CGColor];
    _responseText.returnKeyType =UIReturnKeyDone;
    _responseText.placeholder = @"说点什么吧";
    _responseText.delegate = self;
    _retrunLabel = [[UILabel alloc] initWithFrame:CGRectMake(_responseText.frame.size.width+_responseText.frame.origin.x+10, _responseText.frame.origin.y, 55, _responseText.frame.size.height)];
    _retrunLabel.textAlignment = NSTextAlignmentCenter;
    _retrunLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    _retrunLabel.layer.borderWidth = 1.0;
    _retrunLabel.backgroundColor = [UIColor whiteColor];
    _retrunLabel.layer.cornerRadius = 3.0;
    _retrunLabel.text = @"修改";
    UITapGestureRecognizer *commitComments = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commitComment)];
    _retrunLabel.userInteractionEnabled = YES;
    [_retrunLabel addGestureRecognizer:commitComments];
    
    isChange = NO;
    [_bgTextView addSubview:_responseText];
    [_bgTextView addSubview:_retrunLabel];
    
    [self.view addSubview:_configureTableView];
       [self.view addSubview:_bgTextView];
    _bgTextView.hidden =YES;
    [self readUserDeafultsOwn];
    // Do any additional setup after loading the view from its nib.
}
-(void)commitComment{
    
     [_responseText resignFirstResponder];
     if(_responseText.text.length!=0)
         isChange =YES;
    
    if(index_com ==1){
        _user.name = _responseText.text;
    }else if(index_com ==3){
     _user.location = _responseText.text;
    }
    _bgTextView.hidden =YES;
    [self.configureTableView reloadData];
}
-(void)selectLeftAction:(id)sender{
    if(isChange){
        [self showSheetSource:-1];
    }else{
          [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)selectRightAction:(id)sender{
    [self loadInfo:1];
    isChange = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
            return  4;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0){
     return 80;
    }else {
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingTableViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
            
        case 0://对应各自的分区
            
            [[cell textLabel]  setText:[_section objectAtIndex:indexPath.row]];//给cell添加数据
           
            //log(@"w %f,h %f",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
            if(_user){
                NSString *myImgUrl = _user.cover;
                NSString *jap = @"http://";
                NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
                if(_user.cover){
                    if(foundObj.length>0) {
                        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:myImgUrl]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                    }else {
                        NSMutableString * temp = [[NSMutableString alloc] initWithString:getPictureUrl];
                        [temp appendString:_user.cover];
                        [temp appendString:@"!small"];
                        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:temp]  placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0] ;
                    }
                }else {
                    cell.imageView.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
                }
            }
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = 40;
            break;
        case 1:
                [[cell textLabel]  setText:[NSString stringWithFormat:@"%@:%@",[_section objectAtIndex:indexPath.row],_user.name]];
                       break;
        case 2:
                [[cell textLabel]  setText:[NSString stringWithFormat:@"%@:%@",[_section objectAtIndex:indexPath.row],[_user.sex isEqualToString:@"f"]?@"女": @"男"]];
         
            break;
        case 3:
            [[cell textLabel]  setText:[NSString stringWithFormat:@"%@:%@",[_section objectAtIndex:indexPath.row],_user.location]];
            break;
            
    }
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
            switch (indexPath.row) {
                case 0:
                    [self showSheetSource:0];
                    return;
                    break;
                case 1:
                    _bgTextView.hidden = NO;
                    index_com = 1;
                    _responseText.placeholder =@"新的昵称: ";
                    [_responseText becomeFirstResponder];
                    return;
                    break;
                case 2:
                    [self showSheetSource:2];
                    return;
                    break;
                case 3:
                    _bgTextView.hidden = NO;
                    index_com = 3;
                     _responseText.placeholder =@"新的所在地: ";
                    [_responseText becomeFirstResponder];
                    return;
                    break;
            }
}


- (void)showSheetSource:(NSInteger)tag{
    // log(@"showSheet");
     [_responseText resignFirstResponder];
    UIActionSheet *actionSheet ;
    if(tag<0){
        actionSheet= [[UIActionSheet alloc]
                      initWithTitle:@"确定取消修改？"
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles:@"确定",nil];
    }else  if(tag==0){
        
    actionSheet= [[UIActionSheet alloc]
                                  initWithTitle:@"请选择照片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册中选择", @"拍照",nil];
    }else{
        actionSheet= [[UIActionSheet alloc]
                      initWithTitle:@"性别"
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles:@"男", @"女",nil];
    
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = tag;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag <0){
        
        
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1) {
            return;
        }

        
    }else if(actionSheet.tag==0){
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 1) {
        //   [self showAlert:@"第一项"];
        sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:sourceType])
        {
            [self showAlert:@"相机不可用，使用相册"];
            return;
            // sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
    }else if(buttonIndex == 2) {
        
        //  [self showAlert:@"第二项"];
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    //imagePickerController.showsCameraControls = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
    }else{
        
        if (buttonIndex == 0) {
            if(![_user.sex isEqualToString:@"m"])
                isChange = YES;
            _user.sex =@"m";
        }else if (buttonIndex == 1) {
            if(![_user.sex isEqualToString:@"f"])
                isChange = YES;
          _user.sex =@"f";
        }else if(buttonIndex == 2) {
        
        return;
      }
        [self.configureTableView reloadData];
    }
}

-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self performSelector:@selector(saveImage:) withObject:image];
    
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//将照片保存
-(void)saveImage:(UIImage *)image
{
    
    //    NSData *imageData = UIImagePNGRepresentation(image);
    //    if(imageData == nil)
    //    {
    //        imageData = UIImageJPEGRepresentation(image, 1.0);
    //    }
    _image = [self imageWithImage:image scaledToSize:CGSizeMake(80, 80)];
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
    }
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
    }
    _user.cover = fileName;
    _imageName = fileName;
    [self uploadFiles];
    image =nil;
}

- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
#pragma warning 您需要加上自己的bucket和secret
    NSString * bucket = @"xiaocheng";
    NSString * secret = @"8giBNZVp2lo8f9c7gf6Q8Wk8BQw=";
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    [mutableDic setObject:[NSString stringWithString:_imageName] forKey:@"path"];//设置保存路径
    /**
     *  这个 mutableDic 可以塞入其他可选参数 见：http://docs.upyun.com/api/form_api/#Policy%e5%86%85%e5%ae%b9%e8%af%a6%e8%a7%a3
     */
    NSString * signature = @"";
    NSArray * keys = [mutableDic allKeys];
    keys= [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        NSString * value = mutableDic[key];
        signature = [NSString stringWithFormat:@"%@%@%@",signature,key,value];
    }
    signature = [signature stringByAppendingString:secret];
    
    return @{@"signature":[signature MD5],
             @"policy":[self dictionaryToJSONStringBase64Encoding:mutableDic],
             @"bucket":bucket};
}

- (void)uploadFiles
{
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    _progress.hidden = NO;
    [_progress removeFromSuperview];
    _progress= [SDDemoItemView demoItemViewWithClass:[SDBallProgressView class]];
    _progress.frame = [UIScreen mainScreen].bounds;//CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-100, 200, 200);
    [self.view addSubview:_progress];
    NSData * fileData;
    fileData=UIImageJPEGRepresentation(_image,1.0);
    
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:fileData];//获取文件信息
    
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    NSString * signature = signaturePolicyDic[@"signature"];
    NSString * policy = signaturePolicyDic[@"policy"];
    NSString * bucket = signaturePolicyDic[@"bucket"];
    
    __weak typeof(self)weakSelf = self;
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
    [manager uploadWithFile:fileData policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
        log(@"%f",percent);
        
        weakSelf.progress.progressView.progress =percent;        log(@"progress is %f", weakSelf.progress.progressView.progress);
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        _progress.hidden =YES;
        //self.propressView.alpha = 0;
        if (completed) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            //        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //                log(@"%@",result);
            [self loadInfo:0];
            [_progress removeFromSuperview];
        }else {
            PopView *pop =[[PopView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 -100, 80, 200, 320)];
            [self.view addSubview:pop];
            [pop setText:@"上传头像失败,请重试"];
            [_progress removeFromSuperview];
            [self.navigationController setNavigationBarHidden:NO animated:NO];

        }
        
        
    }];
    fileData =nil;
}

- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData
                                                 encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}


-(void)loadInfo:(int)check{
    if(check ==0){
        _user.cover = _imageName;
    }
    NSDictionary *parameters;
    NSString *url ;
    url =[NSString stringWithString:cuserinfoUrl];
    parameters = [_user toDictionary];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"Mess Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if(check ==0){
          _response= [[ResponseSimple alloc] initWithDictionary:data error:nil];
            if(_response.stat == YES){
                if(_login){
                    _login.cover = _user.cover;
                    [self saveUserDefaultsOwn:0 data:[_login toDictionary]];
                }else if(_registe){
                    _registe.cover = _user.cover;
                    [self saveUserDefaultsOwn:1 data:[_registe toDictionary]];
                }
                PopView *pop =[[PopView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 -100, 80, 200, 320)];
                [self.view addSubview:pop];
                [pop setText:@"头像修改成功"];
                [self.configureTableView reloadData];
            }
            else{
                PopView *pop =[[PopView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 -100, 80, 200, 320)];
                [self.view addSubview:pop];
                int idx =  [(NSNumber*)[data objectForKey:@"errcode"] intValue];
                [pop setText:[NSString stringWithFormat:@"%@  头像修改失败",[ErrCode errcode:idx]]];
            }
        }else if(check==1){
             _response= [[ResponseSimple alloc] initWithDictionary:data error:nil];
            if(_response.stat){
                if(_login){
                    _login.name = _user.name;
                    _login.location = _user.location;
                    _login.sex = _user.sex;
                    [self saveUserDefaultsOwn:0 data:[_login toDictionary]];
                }else if(_registe){
                    _registe.name = _user.name;
                    _registe.location = _user.location;
                    _registe.sex = _user.sex;
                    [self saveUserDefaultsOwn:0 data:[_login toDictionary]];
                
                }
                [self.configureTableView reloadData];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [self showAlert:@"个人信息修改失败"];
            }
            
        }
        [self readUserDeafultsOwn];
        log(@"responseMess stat is %d,errcode is %d",_response.stat,_response.errcode);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log(@"Error: %@", error);
}];
}
- (void)saveUserDefaultsOwn:(NSInteger)check data:(NSDictionary*)data{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(check==0){
        NSDictionary *cache=data;
        [userDefaults setObject:cache forKey:LOGIN_INFO];
    }else if(check==1){
        NSDictionary *cache=data;
        [userDefaults setObject:cache forKey:REGISTE_INFO];
    }
    [userDefaults synchronize];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    NSData *imageData = UIImageJPEGRepresentation(image,0.8);
    image = [UIImage imageWithData:imageData];
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
