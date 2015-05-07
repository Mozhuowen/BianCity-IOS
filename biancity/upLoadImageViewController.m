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
@interface upLoadImageViewController ()
{
    int count;
    int index;
    float progressCount;
}
@property(nonatomic,strong)UIProgressView * propressView;
@property (nonatomic,strong) UIAlertView* progressAlert;
@property (nonatomic,strong) UIButton * imageButton;
@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UIImageView *iconAddrImage;
@property (nonatomic,strong) UILabel *addrLabel;
@property (nonatomic,strong) UITextField *townNameTextFiled;
@property (nonatomic,strong) UITextView *summaryTextView;
@property (nonatomic,strong) UIButton* saveButton;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UILabel *placeholder;
@property (nonatomic) CGPoint originPoint;
@property (nonatomic,strong) GeoInfo* geoinfo;
@property (nonatomic,strong) UIImage* GeoImage;
@property (nonatomic,strong) UILabel *msgIamgeButtonLabel;
@property (nonatomic,strong) UILabel *msgSaveButtonLabel;
@end

@implementation upLoadImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建边城";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.view.frame =[UIScreen mainScreen].bounds;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+200);
   // NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(40,10,self.view.frame.size.width-80,self.view.frame.size.width-80)];
    [_imageButton addTarget:self action:@selector(showSheetSource:) forControlEvents:UIControlEventTouchUpInside];
    // _imageButton.titleLabel.textColor = [UIColor grayColor];
    [_imageButton.layer setBorderWidth:1.0];
    [_imageButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
     //[_imageButton setTitle:@"点击选择封面照片" forState:UIControlStateNormal];
    _msgIamgeButtonLabel = [[UILabel alloc] initWithFrame:_imageButton.frame];
    _msgIamgeButtonLabel.textAlignment = NSTextAlignmentCenter;
    _msgIamgeButtonLabel.text =@"点击选择封面照片";
    _msgIamgeButtonLabel.tag = 111;
    
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, _imageButton.frame.origin.y+_imageButton.frame.size.height+15, 70, 12)];
    _msgLabel.text =@"地址信息";
    _msgLabel.textColor =[UIColor grayColor];
    _iconAddrImage = [[UIImageView alloc] initWithFrame:CGRectMake(_msgLabel.frame.origin.x+_msgLabel.frame.size.width+2,  _imageButton.frame.origin.y+_imageButton.frame.size.height+10, 20, 20)];
    _iconAddrImage.image = [UIImage imageNamed:@"ic_location_large"];
    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconAddrImage.frame.origin.x+22,  _imageButton.frame.origin.y+_imageButton.frame.size.height+15, self.view.frame.size.width-(_iconAddrImage.frame.origin.x+22), 12)];
    NSMutableString *addr = [[NSMutableString alloc] initWithString:@""];
    [addr appendString:(_geoinfo.province!=nil?_geoinfo.province:@"")];
    [addr appendString:(_geoinfo.city!=nil?_geoinfo.city:@"")];
    [addr appendString:_geoinfo.freeaddr!=nil?_geoinfo.freeaddr:@""];
    _addrLabel.text= addr;
    _townNameTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(4,  _imageButton.frame.origin.y+_imageButton.frame.size.height+42, self.view.frame.size.width-8, 30)];
    _townNameTextFiled.placeholder = @"边城名字";
    _townNameTextFiled.delegate =self;
    _townNameTextFiled.returnKeyType =UIReturnKeyDone;
    _townNameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    _summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(4, _townNameTextFiled.frame.origin.y+40, self.view.frame.size.width-8, 80)];
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
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, _summaryTextView.frame.origin.y+100, 200, 40)];
    _saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _saveButton.layer.borderColor =[[UIColor blueColor] CGColor];
    _saveButton.layer.borderWidth = 1.0;
    _saveButton.layer.cornerRadius = 4.0;
    _saveButton.backgroundColor = [UIColor blueColor];
//    _saveButton.tintColor = [UIColor whiteColor];
//    _saveButton.titleLabel.text = @"保存到草稿箱";
    _msgSaveButtonLabel =[[UILabel alloc] initWithFrame:_saveButton.frame];
    _msgSaveButtonLabel.textAlignment =NSTextAlignmentCenter;
    _msgSaveButtonLabel.textColor = [UIColor whiteColor];
    _msgSaveButtonLabel.text = @"保存到草稿箱";
   [_bgScrollView addSubview:_imageButton];
    [_bgScrollView addSubview:_msgIamgeButtonLabel];
     _propressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    self.propressView.frame = CGRectMake(5,5, self.view.frame.size.width-50, 5);
    self.propressView.backgroundColor= [UIColor grayColor];
    
    UIView * myview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width-20, 30)];
    [myview addSubview:self.propressView];
    _progressAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传图片中，请稍等" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [_progressAlert setValue:myview forKey:@"accessoryView"];
    index = 0;
    progressCount=0.0;
    [_bgScrollView addSubview:_msgLabel];
    [_bgScrollView addSubview:_iconAddrImage];
     [_bgScrollView addSubview:_addrLabel];
    [_bgScrollView addSubview:_townNameTextFiled];
    [_bgScrollView addSubview:_summaryTextView];
     [_bgScrollView addSubview:_placeholder];
    [_bgScrollView addSubview:_saveButton];
    [_bgScrollView addSubview:_msgSaveButtonLabel];
    [_bgScrollView setScrollEnabled:YES];
    [_bgScrollView setShowsVerticalScrollIndicator:YES];
    [self.view addSubview:_bgScrollView];
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
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)selectRightAction:(id)sender{
    [_summaryTextView resignFirstResponder];
    [_townNameTextFiled resignFirstResponder];
    if([self checkInfo])
      [self uploadFiles];
    else
    [self showAlert:@"信息不足，请补充完整"];
    
    [self.navigationController pushViewController:nil  animated:NO];
}
-(BOOL)checkInfo{
    if(_geoinfo!=nil&&_GeoImage!=nil&&_townNameTextFiled.text.length!=0&&_summaryTextView.text.length!=0)
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
    NSMutableString *addr = [[NSMutableString alloc] initWithString:@""];
    [addr appendString:(_geoinfo.province!=nil?_geoinfo.province:@"")];
    [addr appendString:(_geoinfo.city!=nil?_geoinfo.city:@"")];
    [addr appendString:_geoinfo.freeaddr!=nil?_geoinfo.freeaddr:@""];
    _addrLabel.text= addr;
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
//-(void)photoTop:(id)sender{
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    //判断是否有摄像头
//    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
//    {
//        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;   // 设置委托
//    imagePickerController.sourceType = sourceType;
//    imagePickerController.allowsEditing = YES;
//    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
//}
-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"警告"
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
//将照片保存到disk上
-(void)saveImage:(UIImage *)image
{
    
//    NSData *imageData = UIImagePNGRepresentation(image);
//    if(imageData == nil)
//    {
//        imageData = UIImageJPEGRepresentation(image, 1.0);
//    }
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.width-80)];
   bg.image= image;
    [_imageButton addSubview:bg];
    _imageButton.imageView.image= image;
    _msgIamgeButtonLabel.hidden =YES;
    //NSLog(@"width is %f,height is %f", image.size.width,image.size.height);
}
- (void) setUploadGeoInfo:(GeoInfo*) sender{
    _geoinfo = sender;
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
        NSMutableString *fileName = [[NSMutableString alloc] init];
        for(int i=0;i<8;i++){
            [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
        }
        for(int i=0;i<8;i++){
            [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
        }

        [mutableDic setObject:fileName forKey:@"path"];//设置保存路径
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
    if(index==0)
    [_progressAlert show];
    
    // self.propressView.frame = alert1.frame;
    // [alert1 addSubview:self.propressView];
    // NSString * url = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpeg"];
    int idx = index;
    NSData * fileData;
    if(idx==0)
    {
        fileData=UIImagePNGRepresentation(_GeoImage);
    }//[NSData
    else{
        fileData=UIImagePNGRepresentation(_imageButton.imageView.image);
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
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        UIAlertView * alert;
        //self.propressView.alpha = 0;
        if (completed) {
            progressCount +=self.propressView.progress;
            if(idx ==1){
                alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                NSLog(@"%@",result);
                [_progressAlert dismissWithClickedButtonIndex:0 animated:NO];
                self.propressView.progress= 0;
                progressCount=0.0;
                [alert show];
                index =0;
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
    index ++;
}

- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData
                                                 encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
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
