//
//  addStoryViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "addStoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "UMUUploaderManager.h"
#import "NLViewController.h"
#import "ApplyTown.h"
#import "TownStory.h"
#import <CommonCrypto/CommonDigest.h>
#import "ResponseStory.h"
#import "SDProgressView.h"
#import "SDDemoItemView.h"
#import "PopView.h"
#import "NSData+MD5Digest.h"

@interface addStoryViewController ()
{
    int count_images;
    int index_images;
    float progressCount;
    BOOL isChange;
}
@property (nonatomic) BOOL upLoadingfalg;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIImageView* wallImage;
@property (nonatomic,strong) NSString *wallimagelabel;
@property (nonatomic,strong) UILabel *bgsesciLabel;
@property (nonatomic,strong) UITextField * titleTextField;
@property (nonatomic,strong) UITextView * descriTextView;
@property (nonatomic,strong) UILabel *placeholder;
@property (nonatomic,strong) NSMutableArray* addingImages;
@property (nonatomic,strong) UIView *bgImages;
@property (nonatomic,strong) UIView *save;
@property (nonatomic,strong) UIImageView *imagesLabel;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *imageNames;
@property (nonatomic) NSInteger  switchPickerFlag;
@property(nonatomic,strong)UIProgressView * propressView;
@property (nonatomic,strong) UIAlertView* progressAlert;
@property (nonatomic,strong) ResponseStory *responseStory;
@property (nonatomic,strong) SDDemoItemView *progress;
@end

@implementation addStoryViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    _townstory = [[TownStory alloc] init];
    _townstory.images = [[NSMutableArray alloc] init];
//    self.navigationItem.leftBarButtonItem =
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
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
    
    self.view.frame =[UIScreen mainScreen].bounds;
    _imageNames= [[NSMutableArray alloc] init];
    _images = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"创建故事";
    self.view.frame = [UIScreen mainScreen].bounds;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width, _bgScrollView.frame.size.height+100);
    _wallImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bgScrollView.frame.size.width, _bgScrollView.frame.size.width*9/16)];
    _wallImage.tag = 100;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSheetSource:)];
    _wallImage.userInteractionEnabled = YES;
    [_wallImage addGestureRecognizer:tap];
    _bgsesciLabel = [[UILabel alloc] initWithFrame:_wallImage.frame];
    _bgsesciLabel.textAlignment = NSTextAlignmentCenter;
    _bgsesciLabel.text = @"点击选择封面照片";
    _wallImage.layer.borderWidth =0.5;
    _wallImage.layer.borderColor = [[UIColor colorWithRed:(10*16+8)/255.0 green:(10*16+11)/255.0 blue:(10*16+13)/255.0 alpha:1.0] CGColor];
    _bgImages.backgroundColor = [UIColor whiteColor];
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _wallImage.frame.size.height+4, _wallImage.frame.size.width, 30)];
    _titleTextField.placeholder =@"标题";
    _titleTextField.delegate =self;
    _titleTextField.returnKeyType =UIReturnKeyDone;
    _descriTextView =[[UITextView alloc] initWithFrame:CGRectMake(0, _wallImage.frame.size.height+_titleTextField.frame.size.height+8, _wallImage.frame.size.width, 120)];
   // _descriTextView.backgroundColor = [UIColor grayColor];
    _descriTextView.returnKeyType =UIReturnKeyDone;
    _descriTextView.delegate = self;
    _descriTextView.font = [UIFont systemFontOfSize:16];
    _descriTextView.layer.borderWidth =0.5;
    _descriTextView.layer.borderColor = [[UIColor colorWithRed:(10*16+8)/255.0 green:(10*16+11)/255.0 blue:(10*16+13)/255.0 alpha:1.0] CGColor];
    _placeholder =[[UILabel alloc] initWithFrame:CGRectMake(_descriTextView.frame.origin.x+2, _descriTextView.frame.origin.y+10, 120, 12) ];
    _placeholder.text =@"说点什么吧";
    _placeholder.backgroundColor = [UIColor clearColor];
    _bgImages =[[UIView alloc] initWithFrame:CGRectMake(0,_descriTextView.frame.size.height+_descriTextView.frame.origin.y+20, _bgScrollView.frame.size.width, [UIScreen mainScreen].bounds.size.width/4)];
//    _bgImages.layer.borderWidth =1.0;
    UITapGestureRecognizer *tapImages = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSheetSource:)];
    _imagesLabel =[[UIImageView alloc] initWithFrame:CGRectMake(1, 1,[UIScreen mainScreen].bounds.size.width/4-2, _bgImages.frame.size.height-2)];
    _imagesLabel.image = [UIImage imageNamed:@"ic_add_photo"];
    _imagesLabel.userInteractionEnabled =YES;
    [_imagesLabel addGestureRecognizer:tapImages];
    //[_bgImages.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage.png"]] CGColor]];
    //_bgImages.backgroundColor = [UIColor grayColor];
    _save =[[UIView alloc] initWithFrame:CGRectMake(5, _bgImages.frame.origin.y+_bgImages.frame.size.height+20, _bgScrollView.frame.size.width-10, 40)];
    _save.backgroundColor = [UIColor colorWithRed:(4*16+7)/255.0 green:11*16/255.0 blue:(15*16+9)/255.0 alpha:1];
    _save.layer.masksToBounds =YES;
    _save.layer.cornerRadius =4.0;
    UILabel *pSave = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _save.frame.size.width, _save.frame.size.height)];
    pSave.textAlignment = NSTextAlignmentCenter;
    pSave.textColor = [UIColor whiteColor];
    pSave.text = @"保存到草稿箱";
    UITapGestureRecognizer *tapCache = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveUserDefaultsOwn)];
    _save.userInteractionEnabled = YES;
    [_save addGestureRecognizer:tapCache];
    _placeholder.enabled = NO;
    index_images = 0;
    progressCount=0.0;
    if(_cacheid == nil){
        _cacheid = [self createFileName];
    }
     //_bgScrollView.backgroundColor =[UIColor grayColor];
    [_bgScrollView addSubview:_wallImage];
    [_bgScrollView addSubview:_bgsesciLabel];
    [_bgScrollView addSubview:_titleTextField];
    [_bgScrollView addSubview:_descriTextView];
    [_bgScrollView addSubview:_placeholder];
    [_bgScrollView addSubview:_bgImages];
    [_bgImages addSubview:_imagesLabel];
    [_bgScrollView addSubview:_save];
    [_save addSubview:pSave];
    isChange = NO;
    [self.view addSubview:_bgScrollView];
    
    if(_isComeFormCache){
        [self readUserDeafultsOwn];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectLeftAction:(id)sender{
    if(isChange){
        [self changeAlert];
    }else {
        [self.navigationController popViewControllerAnimated:YES];

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag ==100){
        switch (buttonIndex) {
            case 0:
                log(@"0");
                return;
                break;
                
            case 1:
                [self saveUserDefaultsOwn];
                 [self.navigationController popViewControllerAnimated:YES];
                return;
                break;
            case 2:
                 [self.navigationController popViewControllerAnimated:YES];
                return;
                break;
        }
    }
}
-(void)changeAlert{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"是否保存到草稿箱？"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"保存",@"不保存", nil];
    alert.tag = 100;
    [alert show];
}

-(void)selectRightAction:(id)sender{
    if(_upLoadingfalg){
        [self showAlert:@"上传中，请稍等"];
    }
    else {
    if(self.wallImage.image!=nil&&_titleTextField.text.length!=0&&_descriTextView.text.length!=0){
        _townstory.title = _titleTextField.text;
        _townstory.content = _descriTextView.text;
        _townstory.townid =_townid;
        _upLoadingfalg = YES;
         [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self saveUserDefaultsOwn];
        progressCount=0.0;
        [self uploadFiles];
        
    }else{
        [self showAlert:@"信息不全，请补充完整"];
    }
    
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    // self.summaryTextView.text =  textView.text;
    if (textView.text.length == 0) {
        self.placeholder.text = @"说点什么吧";
    }else{
        self.placeholder.text = @"";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     if(textField.text.length!=0)
         isChange =YES;
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        if(text.length != 0)
              isChange =YES;
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}
- (void)showSheetSource:(UITapGestureRecognizer* )sender {
    // log(@"showSheet");
    UIView *vi = [sender view];
    _switchPickerFlag = vi.tag;
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
   // imagePickerController.allowsEditing = YES;
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
      isChange =YES;
    if(100==_switchPickerFlag){
    NLViewController *pic = [[NLViewController alloc] initWithNibName:@"NLViewController" bundle:nil];
    pic.bgImage = image;
    pic.Nl_delegate =self;
        [self.navigationController pushViewController:pic  animated:NO];
    }else {
 //需要以模态的形式展示
[self performSelector:@selector(saveImage:) withObject:image];
    }
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
  
    NSString *fileName =[self createFileName];
    if((_wallImage.image.size.width*_wallImage.image.size.height/1000000.00)>2){
       image = [self imageWithImageToScreen:image];
    }
    StoryImage *img = [[StoryImage alloc] init];
    img.imagename = fileName;
    NSData *tp =UIImageJPEGRepresentation(image, 1.0);
    img.md5 = [tp MD5HexDigest];//=[[NSString alloc] initWithData:[tp md]  encoding:NSUnicodeStringEncoding];//[self image_md5:tp];
    log(@"Image MD5 %@",img.md5);
    img.list_index =[[NSNumber alloc] initWithLongLong:([_images count])];
    img.size = [[NSNumber alloc] initWithDouble:image.size.width*image.size.height];
    [_townstory.images addObject:img];
    
    tp = nil;
    [self saveImage:fileName image:image];
    image = [self imageWithImage:image scaledToSize:_imagesLabel.frame.size];
    [_images addObject:image];
    [_imageNames addObject:fileName];
    UIImageView *temp=[[UIImageView alloc] initWithFrame:_imagesLabel.frame];
    temp.image = image;
    temp.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImages addSubview:temp];
    if([_images count]==4){
         CGRect rect = _bgImages.frame;
        rect.size.height += _imagesLabel.frame.size.width;
        _bgImages.frame =rect;
        rect = _save.frame;
        rect.origin.y +=_imagesLabel.frame.size.width;
        _save.frame = rect;
        rect = _imagesLabel.frame;
        rect.origin.x = 0;
        rect.origin.y +=_imagesLabel.frame.size.width;
        _imagesLabel.frame = rect;
        CGPoint point= _bgScrollView.contentOffset;
        point.y += _imagesLabel.frame.size.width;
        _bgScrollView.contentOffset = point;
    }else if([_images count]==8){
        _imagesLabel.hidden = YES;
    }else{
        _imagesLabel.frame =  CGRectMake(_imagesLabel.frame.origin.x+_imagesLabel.frame.size.width, _imagesLabel.frame.origin.y, _imagesLabel.frame.size.width, _imagesLabel.frame.size.height);
    }
    
    [_bgImages setNeedsDisplay];
    tp = nil;
    image = nil;
}
-(NSString *)image_md5:(NSData * )name{
 const char *str = [name bytes];
    if (str == NULL) {
        str = "";
    }
    log(@"md5%s",str);
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                             r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    log(@"Image Md5 is %@",result);
    return result;
}
-(NSString*)createFileName{
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
    }
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
    }
    return fileName;
}
-(void)changeiamge:(UIImage*)image{
    _wallImage.image = image;
    _wallimagelabel = [self createFileName];
    _bgsesciLabel.hidden= YES;
    _townstory.cover = _wallimagelabel;
    log(@"changeIamge");
};

- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
#pragma warning 您需要加上自己的bucket和secret
    NSString * bucket = @"xiaocheng";
    NSString * secret = @"8giBNZVp2lo8f9c7gf6Q8Wk8BQw=";
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    if(index_images==0){
        [mutableDic setObject:[NSString stringWithString:_wallimagelabel] forKey:@"path"];//设置保存路径
    }
    else{
        [mutableDic setObject:[_imageNames objectAtIndex:(index_images-1)] forKey:@"path"];//设置保存路径
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
    _progress.hidden = NO;
    if(index_images==0){
        
       
        _progress= [SDDemoItemView demoItemViewWithClass:[SDBallProgressView class]];
        _progress.frame = [UIScreen mainScreen].bounds;//
        [self.view addSubview:_progress];
    }
    int idx = index_images;
    NSData * fileData;
    if(idx==0)
    {
      
        fileData=UIImageJPEGRepresentation(_wallImage.image,1.0);
        //UIImagePNGRepresentation(_wallImage.image);
         log(@"image size is %fM,file length is %fM",_wallImage.image.size.width*_wallImage.image.size.height/1000000.00,fileData.length/1000000.00);
    }//[NSData
    else{
        UIImage *im =  [self readeIamge:[_imageNames objectAtIndex:idx-1]];
        fileData=[self readeIamgeData:[_imageNames objectAtIndex:idx-1]];
        //UIImageJPEGRepresentation(im,1.0);//UIImagePNGRepresentation([self readeIamge:[_imageNames objectAtIndex:idx-1]]);
         log(@"image size is %fM,file length is %fM",im.size.width*im.size.height/1000000.00,fileData.length/1000000.00);
        im = nil;
    }
   

    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:fileData];//获取文件信息
    
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    NSString * signature = signaturePolicyDic[@"signature"];
    NSString * policy = signaturePolicyDic[@"policy"];
    NSString * bucket = signaturePolicyDic[@"bucket"];
    
    __weak typeof(self)weakSelf = self;
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
[manager uploadWithFile:fileData policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
        log(@"%f",percent);
        weakSelf.progress.progressView.progress =percent/([_images count]+1)+progressCount;
        log(@"progress is %f", weakSelf.progress.progressView.progress);
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        //self.propressView.alpha = 0;
        if (completed) {
        index_images ++;
            progressCount += 1.0/([_images count]+1);
          if(idx ==[_images count]){
                [_progressAlert dismissWithClickedButtonIndex:0 animated:NO];
                self.propressView.progress= 0;
                progressCount=0.0;
                // [alert show];
                index_images =0;
                
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [self loadInfo:0];
                _progress.hidden = YES;
            }else {
               
                [weakSelf uploadFiles];
            }
        }else {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 40)];
            [self.view addSubview:pop];
               _upLoadingfalg = NO;
              progressCount=0.0;
            [pop setText:@"o(>﹏<)o 网络有点糟糕,以保存至草稿箱,请稍后再试"];
            _progress.hidden = YES;
        }
      
        
    }];
    fileData =nil;
    fileInfo = nil;
    signaturePolicyDic = nil;
    signature = nil;
    policy = nil;
    bucket = nil;
    manager = nil;
}

- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData
                                                 encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}


#pragma loading Infomation
-(void)loadInfo:(int)check{
    NSDictionary *parameters = [_townstory toDictionary];
    //log(@"%@",parameters);
    NSString *url =[NSString stringWithString:getCreatePutao];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"create story Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
     
            self.responseStory = [[ResponseStory alloc] initWithDictionary:data error:nil];
        log(@"creatStroy stat is %d,errcode is %d",_responseStory.stat,_responseStory.errcode);
        _upLoadingfalg = NO;
        [self.navigationController setNavigationBarHidden:NO animated:NO];

        if(_responseStory.stat){
        [self.navigationController popViewControllerAnimated:NO];
        [self deletecache];
        _wallImage =nil;
        PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 40)];
        [self.view addSubview:pop];
            [pop setText:@"\(^o^)/~ 新建成功"];
        }else {
            
            PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 40)];
            [self.view addSubview:pop];
            int idx =  [(NSNumber*)[data objectForKey:@"errcode"] intValue];
            [pop setText:[NSString stringWithFormat:@"o(>﹏<)o %@",[ErrCode errcode:idx]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log(@"Error: %@", error);
        PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 40)];
           _upLoadingfalg = NO;
        [self.view addSubview:pop];
        [pop setText:@"o(>﹏<)o 网络糟糕，请稍后重试"];
    }];
}
#pragma   草稿箱


-(NSData*)readeIamgeData:(NSString*)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSData * result;
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if(blHave){
        result = [NSData dataWithContentsOfFile:uniquePath];
    }
    return  result;
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
        log(@"already have");
        return ;
    }
    NSData * imagedata = UIImageJPEGRepresentation(image,1.0);
    BOOL result = [imagedata writeToFile:uniquePath atomically:YES];
    if (result) {
        log(@"save %@ image success",imagename);
    }else {
        log(@"no success");
    }
}
-(void)removeImageFile:(NSString*)imageName{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        log(@"no  have");
        return ;
    }else {
        log(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            log(@"dele success");
        }else {
            log(@"dele fail");
        }
        
    }
}
- (void)saveUserDefaultsOwn{
      isChange =NO;
    townCache *item1 = [[townCache alloc] init];
    item1.title = _titleTextField.text;
    item1.descri = _descriTextView.text;
    item1.coverName = _townstory.cover;
    item1.type = 1;
    item1.townid =_townid;
    item1.imagesName= _imageNames;
    NSDictionary *cache;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    cache = [userDefaults objectForKey:@"cache"];
       log(@"save button,cache %@",cache);
    NSDictionary * para = [item1 toDictionary];
    NSMutableDictionary *ad;
    if(cache !=nil){
        ad= [[NSMutableDictionary alloc] initWithDictionary:cache];
        
    }else{
        ad= [[NSMutableDictionary alloc] init];
    }
    [ad setObject:para forKey:_cacheid];
    log(@"item1 %@",ad);
    [userDefaults setObject:ad forKey:@"cache"];
    [userDefaults synchronize];
    
    [self saveImage: item1.coverName image:_wallImage.image];
//    for(int i=0;i<[_images count];i++){
//        [self saveImage:[item1.imagesName objectAtIndex:i] image:[_images objectAtIndex:i]];
//    }
    if(!_upLoadingfalg){
        PopView * pop = [[PopView alloc] initWithFrame:CGRectMake(0, 400, [UIScreen mainScreen].bounds.size.width, 40)];
        [self.view addSubview:pop];
        [pop setText:@"成功保存\(^o^)/"];
    }
}
-(void)setCacheBegin:(townCache*)cache key:(NSString*)keyid{
    _wallimagelabel = cache.coverName;
    _bgsesciLabel.hidden= YES;
    _townstory.cover = _wallimagelabel;
    _cacheid = keyid;
    _townid = cache.townid;
    _descriTextView.text = cache.descri;
    _titleTextField.text = cache.title;
    _titleTextField.placeholder =@"";
    _placeholder.text = @"";
    _wallImage.image = [self readeIamge:cache.coverName];
    for(int i=0;i<[cache.imagesName count];i++){
        [self saveImage:[self readeIamge:[cache.imagesName objectAtIndex:i]] imageName:[cache.imagesName objectAtIndex:i]];
    }
    
    [self.view setNeedsDisplay];
    log(@"staory cache %@",cache);
}
- (void) readUserDeafultsOwn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache = [[NSDictionary alloc] init];
    cache = [userDefaults objectForKey:@"cache"];
    townCache *item1  = [[townCache alloc] initWithDictionary:[cache objectForKey:_cacheid] error:nil];;
    [self setCacheBegin:item1 key:_cacheid];
}

//将照片保存
-(void)saveImage:(UIImage *)image imageName:(NSString*)imageName
{
    
    //    NSData *imageData = UIImagePNGRepresentation(image);
    //    if(imageData == nil)
    //    {
    //        imageData = UIImageJPEGRepresentation(image, 1.0);
    //    }
    
    NSString *fileName =imageName;
    [self saveImage:imageName image:image];
   image = [self imageWithImage:image scaledToSize:_imagesLabel.frame.size];
    [_images addObject:image];
    [_imageNames addObject:fileName];
    UIImageView *temp=[[UIImageView alloc] initWithFrame:_imagesLabel.frame];
    temp.image = image;
    temp.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImages addSubview:temp];
    if([_images count]==4){
        CGRect rect = _bgImages.frame;
        rect.size.height += _imagesLabel.frame.size.width;
        _bgImages.frame =rect;
        rect = _save.frame;
        rect.origin.y +=_imagesLabel.frame.size.width;
        _save.frame = rect;
        rect = _imagesLabel.frame;
        rect.origin.x = 0;
        rect.origin.y +=_imagesLabel.frame.size.width;
        _imagesLabel.frame = rect;
        CGPoint point= _bgScrollView.contentOffset;
        point.y += _imagesLabel.frame.size.width;
        _bgScrollView.contentOffset = point;
    }else if([_images count]==8){
        _imagesLabel.hidden = YES;
    }else{
        _imagesLabel.frame =  CGRectMake(_imagesLabel.frame.origin.x+_imagesLabel.frame.size.width, _imagesLabel.frame.origin.y, _imagesLabel.frame.size.width, _imagesLabel.frame.size.height);
    }
    StoryImage *img = [[StoryImage alloc] init];
    img.imagename = fileName;
    NSData *tp =UIImageJPEGRepresentation(image, 1.0);
    img.md5 =[self image_md5:[[NSString alloc] initWithData:tp encoding:NSUTF8StringEncoding]];
    img.list_index =[[NSNumber alloc] initWithLongLong:([_images count]-1)];
    img.size = [[NSNumber alloc] initWithDouble:image.size.width*image.size.height];
    [_townstory.images addObject:img];
    [_bgImages setNeedsDisplay];
}
-(void)deletecache{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *cache = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"cache"]];
    [cache removeObjectForKey:_cacheid];
    [self removeImageFile:_townstory.cover];
    for(int i =0;i<[_images count];i++){
    [self removeImageFile:[_imageNames objectAtIndex:i]];
    }
    [userDefaults setObject:cache forKey:@"cache"];
    [userDefaults synchronize];
    
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    NSData *imageData = UIImageJPEGRepresentation(image,0.3);
    image = [UIImage imageWithData:imageData];
    
    float scaleX = image.size.width/newSize.width;
    float scaleY = image.size.height/newSize.height;
    if(scaleX>scaleY){
        newSize.height *= scaleY/scaleX;
    }else{
        newSize.width *= scaleX/scaleY;
    }
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

-(UIImage*)imageWithImageToScreen:(UIImage*)image
{
    CGSize newSize = CGSizeMake(1450, 1450);
    
    float scaleX = image.size.width/newSize.width;
    float scaleY = image.size.height/newSize.height;
    if(scaleX>scaleY){
        newSize.height *= scaleY/scaleX;
    }else{
        newSize.width *= scaleX/scaleY;
    }
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
