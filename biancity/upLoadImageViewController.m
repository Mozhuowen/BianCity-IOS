//
//  upLoadImageViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "upLoadImageViewController.h"
#import "GeoInfo.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "townViewController.h"
#import "ApplyTown.h"
#import "responseApplyTown.h"
#import "MsgEncrypt.h"
#import "SDProgressView.h"
#import "SDDemoItemView.h"
#import "townCache.h"
@interface upLoadImageViewController ()
{
    int count;
    int index;
    float progressCount;
}
@property (nonatomic,strong) responseApplyTown *responseApplyTown;
@property (nonatomic,strong) ApplyTown *requestApplyTown;
@property(nonatomic,strong)UIProgressView * propressView;
@property (nonatomic,strong) UIAlertView* progressAlert;
@property (nonatomic,strong) UIImage * coverimage;
@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UIImageView *iconAddrImage;
@property (nonatomic,strong) UILabel *addrLabel;
@property (nonatomic,strong) UITextField *townNameTextFiled;
@property (nonatomic,strong) UITextView *summaryTextView;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UILabel *placeholder;
@property (nonatomic) CGPoint originPoint;
@property (nonatomic,strong) GeoInfo* geoinfo;
@property (nonatomic,strong) UIImage* GeoImage;
@property (nonatomic,strong) UILabel *msgIamgeButtonLabel;
@property (nonatomic,strong) UILabel *msgSaveButtonLabel;
@property (nonatomic,strong) SDDemoItemView *progressDome;
@property (nonatomic) BOOL uploadFlag;

@end

@implementation upLoadImageViewController
-(void)deletecache{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *cache = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"cache"]];
    [cache removeObjectForKey:_cacheid];
    [self removeImageFile:_requestApplyTown.cover];
    [self removeImageFile:_requestApplyTown.geoinfo.screenpng];
    
    [userDefaults setObject:cache forKey:@"cache"];
    [userDefaults synchronize];

}
-(void)setCacheBegin:(townCache*)cache key:(NSString*)keyid{
    _msgIamgeButtonLabel.text =@"";
    CGRect rect = _msgIamgeButtonLabel.frame;
    rect.origin.x =0;
    rect.origin.y = 0;
    _requestApplyTown.geoinfo = cache.geoinfo;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:rect];
    bg.image =[self readeIamge:cache.coverName];
    _coverimage = bg.image;
    _requestApplyTown.cover = cache.coverName;
    [_msgIamgeButtonLabel addSubview:bg];
    _GeoImage = [self readeIamge:cache.mapIamgeName];
    _geoinfo =cache.geoinfo;
    _cacheid = keyid;
    _summaryTextView.text = cache.descri;
    _townNameTextFiled.text = cache.title;
    _townNameTextFiled.placeholder =@"";
    _placeholder.text = @"";
    NSMutableString *addr = [[NSMutableString alloc] initWithString:@""];
    [addr appendString:(_geoinfo.province!=nil?_geoinfo.province:@"")];
    [addr appendString:(_geoinfo.city!=nil?_geoinfo.city:@"")];
    [addr appendString:_geoinfo.freeaddr!=nil?_geoinfo.freeaddr:@""];
    _addrLabel.text= addr;

    [self.view setNeedsDisplay];
    NSLog(@"cache %@",cache);
}

-(UIImage*)readeIamge:(NSString*)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    UIImage * result;
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if(blHave){
        result = [UIImage imageWithData:[NSData dataWithContentsOfFile:uniquePath]];
    }
    return  result;
}
-(void)saveImage:(NSString*)imagename image:(UIImage*)image{
 
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //并给文件起个文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imagename];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave) {
        NSLog(@"already have");
        return ;
    }
    NSData * imagedata = UIImagePNGRepresentation(image);
    BOOL result = [imagedata writeToFile:uniquePath atomically:YES];
    if (result) {
        NSLog(@"success");
    }else {
        NSLog(@"no success");
    }
}
-(void)removeImageFile:(NSString*)imageName{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}
-(NSString*)createName{
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
    }
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
    }
    return fileName;
}
- (void)saveUserDefaultsOwn{
  
    townCache *item1 = [[townCache alloc] init];
    item1.coverName = _requestApplyTown.cover;
    item1.title = _townNameTextFiled.text;
    item1.descri = _summaryTextView.text;
    item1.type = 0;
    item1.geoinfo = _geoinfo;
    item1.mapIamgeName = _geoinfo.screenpng;
    NSDictionary *cache;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    cache = [userDefaults objectForKey:@"cache"];
    [self saveImage: item1.coverName image:_coverimage];
    [self saveImage:item1.mapIamgeName image:_GeoImage];
    NSLog(@"save button,cache %@",cache);
    NSDictionary * para = [item1 toDictionary];
    NSMutableDictionary *ad;
    if(cache !=nil){
       ad= [[NSMutableDictionary alloc] initWithDictionary:cache];
        
    }else{
        ad= [[NSMutableDictionary alloc] init];
    }
    [ad setObject:para forKey:_cacheid];
    NSLog(@"item1 %@",ad);
    [userDefaults setObject:ad forKey:@"cache"];

    
    [userDefaults synchronize];
}
- (void) readUserDeafultsOwn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   NSDictionary *cache = [[NSDictionary alloc] init];
    cache = [userDefaults objectForKey:@"cache"];
    townCache *item1  = [[townCache alloc] initWithDictionary:[cache objectForKey:_cacheid] error:nil];;
    [self setCacheBegin:item1 key:_cacheid];
//   townCache *item1 = [[townCache alloc] init];
//    for(id key in cache){
//        item1 = [[townCache alloc]initWithDictionary:[cache objectForKey:key] error:nil];
//        UIImageView * bg = [[UIImageView alloc] initWithFrame:_msgIamgeButtonLabel.frame];
//        bg.image = [self readeIamge:item1.coverName];
//        [_msgIamgeButtonLabel addSubview:bg];
//        _summaryTextView.text = item1.descri;
//        _townNameTextFiled.text = item1.title;
//        NSLog(@"cache is %@",item1);
//
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _requestApplyTown = [[ApplyTown alloc] init];
        self.navigationItem.title = @"创建边城";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    if(_cacheid==nil){
        _cacheid = [self createName];
    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.view.frame =[UIScreen mainScreen].bounds;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+200);
    _msgIamgeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,10,self.view.frame.size.width-80,self.view.frame.size.width-80)];
    _msgIamgeButtonLabel.textAlignment = NSTextAlignmentCenter;
    _msgIamgeButtonLabel.text =@"点击选择封面照片";
    _msgIamgeButtonLabel.tag = 111;
    [_msgIamgeButtonLabel.layer setBorderWidth:1.0];
    [_msgIamgeButtonLabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    UITapGestureRecognizer * tapIamge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSheetSource:)];
    _msgIamgeButtonLabel.userInteractionEnabled = YES;
    [_msgIamgeButtonLabel addGestureRecognizer:tapIamge];
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, _msgIamgeButtonLabel.frame.origin.y+_msgIamgeButtonLabel.frame.size.height+15, 70, 12)];
    _msgLabel.text =@"地址信息";
    _msgLabel.textColor =[UIColor grayColor];
    _iconAddrImage = [[UIImageView alloc] initWithFrame:CGRectMake(_msgLabel.frame.origin.x+_msgLabel.frame.size.width+2,  _msgIamgeButtonLabel.frame.origin.y+_msgIamgeButtonLabel.frame.size.height+10, 20, 20)];
    _iconAddrImage.image = [UIImage imageNamed:@"ic_location_large"];
    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconAddrImage.frame.origin.x+22,  _msgIamgeButtonLabel.frame.origin.y+_msgIamgeButtonLabel.frame.size.height+15, self.view.frame.size.width-(_iconAddrImage.frame.origin.x+22), 12)];
    NSMutableString *addr = [[NSMutableString alloc] initWithString:@""];
    [addr appendString:(_geoinfo.province!=nil?_geoinfo.province:@"")];
    [addr appendString:(_geoinfo.city!=nil?_geoinfo.city:@"")];
    [addr appendString:_geoinfo.freeaddr!=nil?_geoinfo.freeaddr:@""];
    _addrLabel.text= addr;
    _townNameTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(4,  _msgIamgeButtonLabel.frame.origin.y+_msgIamgeButtonLabel.frame.size.height+42, self.view.frame.size.width-8, 30)];
    _townNameTextFiled.placeholder = @"边城名字";
    _townNameTextFiled.delegate =self;
    _townNameTextFiled.returnKeyType =UIReturnKeyDone;
    _townNameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    _summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(4, _townNameTextFiled.frame.origin.y+40, self.view.frame.size.width-8, 80)];
    _summaryTextView.font = [UIFont systemFontOfSize:14];
    _summaryTextView.layer.borderWidth = 1.0;
    _summaryTextView.layer.borderColor =[[UIColor grayColor] CGColor];
    _summaryTextView.returnKeyType =UIReturnKeyDone;
    _summaryTextView.delegate = self;
    _summaryTextView.layer.cornerRadius = 5.0;
    _summaryTextView.scrollEnabled =YES;
    _placeholder =[[UILabel alloc] initWithFrame:CGRectMake(_summaryTextView.frame.origin.x+2, _summaryTextView.frame.origin.y+6, 220, 12) ];
    _placeholder.text =@"可以输入最多150字的描述";
    _placeholder.backgroundColor = [UIColor clearColor];
    _placeholder.enabled = NO;

    _msgSaveButtonLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, _summaryTextView.frame.origin.y+100, 200, 40)];
    _msgSaveButtonLabel.textAlignment =NSTextAlignmentCenter;
    _msgSaveButtonLabel.textColor = [UIColor whiteColor];
    _msgSaveButtonLabel.text = @"保存到草稿箱";
    _msgSaveButtonLabel.layer.borderColor =[[UIColor blueColor] CGColor];
    _msgSaveButtonLabel.layer.borderWidth = 1.0;
    _msgSaveButtonLabel.layer.cornerRadius = 4.0;
    UITapGestureRecognizer *tapSave = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveUserDefaultsOwn)];
    _msgSaveButtonLabel.userInteractionEnabled =YES;
    [_msgSaveButtonLabel addGestureRecognizer:tapSave];
    _msgSaveButtonLabel.backgroundColor = [UIColor blueColor];
    [_bgScrollView addSubview:_msgIamgeButtonLabel];
     _propressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];

    _progressAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传图片中，请稍等" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    self.propressView.frame = CGRectMake(8,5, self.view.frame.size.width*4/5-4, 5);
    self.propressView.backgroundColor= [UIColor grayColor];
    
    UIView * myview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 30)];
    [myview addSubview:self.propressView];
    [_progressAlert setValue:myview forKey:@"accessoryView"];
    index = 0;
    progressCount=0.0;
    [_bgScrollView addSubview:_msgLabel];
    [_bgScrollView addSubview:_iconAddrImage];
     [_bgScrollView addSubview:_addrLabel];
    [_bgScrollView addSubview:_townNameTextFiled];
    [_bgScrollView addSubview:_summaryTextView];
     [_bgScrollView addSubview:_placeholder];
    [_bgScrollView addSubview:_msgSaveButtonLabel];
    [_bgScrollView setScrollEnabled:YES];
    [_bgScrollView setShowsVerticalScrollIndicator:YES];
    [self.view addSubview:_bgScrollView];
    if(_isComeFromCache){
        [self readUserDeafultsOwn];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)textViewDidChange:(UITextView *)textView
{
   // self.summaryTextView.text =  textView.text;
    if (textView.text.length == 0) {
        self.placeholder.text = @"可以输入最多150字描述";
    }else{
        self.placeholder.text = @"";
    }
}
-(void)selectLeftAction:(id)sender{
    [_summaryTextView resignFirstResponder];
    [_townNameTextFiled resignFirstResponder];
    if(!_uploadFlag){
        if(_isComeFromCache){
            [self.navigationController popViewControllerAnimated:YES];

            }else{
         [self.navigationController dismissViewControllerAnimated:YES completion:^{}];

        }
    }
}
-(void)selectRightAction:(id)sender{
    [_summaryTextView resignFirstResponder];
    [_townNameTextFiled resignFirstResponder];
    if(_uploadFlag){
        [self showAlert:@"上传中，请稍等"];
    }else {
    if(_requestApplyTown.geoinfo == nil)
        _requestApplyTown.geoinfo = _geoinfo;
    if([self checkInfo]){
        _uploadFlag =YES;
        [self uploadFiles];
    }else{
        [self showAlert:@"信息不足，请补充完整"];
    }
    //[self loadInfo:0];
    _requestApplyTown.descri = _summaryTextView.text;
    _requestApplyTown.townname = _townNameTextFiled.text;
    }
}
-(BOOL)checkInfo{
    if(_geoinfo!=nil&&_GeoImage!=nil&&_townNameTextFiled.text.length!=0&&_summaryTextView.text.length!=0&&_coverimage!=nil)
    return YES;
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
-(void)keyboardWillShow:(id )sender{
    self.originPoint = CGPointMake(_bgScrollView.contentOffset.x, _bgScrollView.contentOffset.y);
    if(_bgScrollView.contentOffset.y<90)
    _bgScrollView.contentOffset = CGPointMake(_bgScrollView.contentOffset.x, 90);
    
}
-(void)keyboardWillHide:(id )sender{
    _bgScrollView.contentOffset= self.originPoint;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;    
    
}


- (void)showSheetSource:(id)sender {
    // NSLog(@"showSheet");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择照片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册中选择", @"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.width-80)];
   bg.image= image;
    [_msgIamgeButtonLabel addSubview:bg];
    _coverimage= image;
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
    }
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
    }
    _requestApplyTown.cover = fileName;
    
}
- (void) setUploadGeoInfo:(GeoInfo*) sender{
    _geoinfo = sender;
    _requestApplyTown.geoinfo = _geoinfo;
};
- (void) setUploadImage:(UIImage*) sender{
    _GeoImage = sender;
};
#pragma upLoadimage
- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
#pragma warning 您需要加上自己的bucket和secret
    NSString * bucket = @"xiaocheng";
    NSString * secret = @"8giBNZVp2lo8f9c7gf6Q8Wk8BQw=";
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    if(index==0){
     [mutableDic setObject:_geoinfo.screenpng forKey:@"path"];//设置保存路径
    }
    else{
      [mutableDic setObject:_requestApplyTown.cover forKey:@"path"];//设置保存路径
    }
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
    if(index==0){
        _progressDome.hidden = NO;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        //[_progressAlert show];
        _progressDome= [SDDemoItemView demoItemViewWithClass:[SDBallProgressView class]];
        _progressDome.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:_progressDome];
    }
    int idx = index;
    NSData * fileData;
    if(idx==0)
    {
        fileData=UIImagePNGRepresentation(_GeoImage);
    }//[NSData
    else{
        fileData=UIImagePNGRepresentation(_coverimage);
    }
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:fileData];//获取文件信息
    
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    NSString * signature = signaturePolicyDic[@"signature"];
    NSString * policy = signaturePolicyDic[@"policy"];
    NSString * bucket = signaturePolicyDic[@"bucket"];
    
    __weak typeof(self)weakSelf = self;
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
    [manager uploadWithFile:fileData policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
        NSLog(@"%f",percent);
        weakSelf.propressView.progress = percent/2+progressCount;
        weakSelf.progressDome.progressView.progress =percent/2+progressCount;
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        UIAlertView * alert;
        //self.propressView.alpha = 0;
        if (completed) {
             index ++;
            progressCount +=self.propressView.progress;
            if(idx ==1){
                alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                NSLog(@"%@",result);
                [_progressAlert dismissWithClickedButtonIndex:0 animated:NO];
                self.propressView.progress= 0;
                progressCount=0.0;
               // [alert show];
                index =0;
                
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [self loadInfo:0];
                   _progressDome.hidden = YES;
            }else {
                [weakSelf uploadFiles];
            }
        }else {
            [_progressAlert dismissWithClickedButtonIndex:0 animated:NO];
            alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            NSLog(@"%@",error);
            [alert show];
        }
        
        
    }];
   
}

- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData
                                                 encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}

-(void)loadInfo:(int)check{
    NSDictionary *parameters=[_requestApplyTown toDictionary];
    NSString *url =[NSString stringWithString:getApplyTownUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    //NSLog(@"%lu",(unsigned long)info.length);
    log(@"ApplyTown Info is %@,length is %lu",info,(unsigned long)info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    log(@"%@,time si %@",signature,strtime);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
       
            _responseApplyTown = [[responseApplyTown alloc] initWithDictionary:data error:nil];
            //[self.bgScrollView headerEndRefreshing];
            // NSLog(@"USer is %@",_User);
            if(_responseApplyTown.stat){
            townViewController *town = [[townViewController alloc]initWithNibName:@"townViewController" bundle:nil];
                self.applyTown_delegate = town;
                [self transfromInfo];
                town.applyTown = _responseApplyTown;
                [self.navigationController pushViewController:town  animated:YES];
                [self deletecache];
            }
            else{
                [self showAlert:@"上传不成功"];
            }
        log(@"APPLYTOWN stat is %d,errcode is %d",_responseApplyTown.stat,_responseApplyTown.errcode);
        log(@"%@",_responseApplyTown);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}

- (void)transfromInfo{
   
    if ([self.applyTown_delegate respondsToSelector:@selector(setApplyTownGeoInfo:)])
    {
        [self.applyTown_delegate setApplyTownGeoInfo:_responseApplyTown];
    }
   
}
#pragma end loading Infomation

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
