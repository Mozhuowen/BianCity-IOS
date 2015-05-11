//
//  addStoryViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "addStoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NLViewController.h"
@interface addStoryViewController ()
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIImageView* wallImage;
@property (nonatomic,strong) UILabel *bgsesciLabel;
@property (nonatomic,strong) UITextField * titleTextField;
@property (nonatomic,strong) UITextView * descriTextView;
@property (nonatomic,strong) UILabel *placeholder;
@property (nonatomic,strong) NSMutableArray* addingImages;
@property (nonatomic,strong) UIView *bgImages;
@property (nonatomic,strong) UIView *save;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *imageNames;
@end

@implementation addStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(selectLeftAction:)];
    _imageNames= [[NSMutableArray alloc] init];
    _images = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"创建故事";
    self.view.frame = [UIScreen mainScreen].bounds;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width, _bgScrollView.frame.size.height+100);
    _wallImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bgScrollView.frame.size.width, _bgScrollView.frame.size.width*9/16)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSheetSource:)];
    _wallImage.userInteractionEnabled = YES;
    [_wallImage addGestureRecognizer:tap];
    _bgsesciLabel = [[UILabel alloc] initWithFrame:_wallImage.frame];
    _bgsesciLabel.textAlignment = NSTextAlignmentCenter;
    _bgsesciLabel.text = @"点击选择封面照片";
    _wallImage.layer.borderWidth =1.0;
    _wallImage.layer.borderColor = [[UIColor grayColor] CGColor];
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
    _descriTextView.layer.borderWidth =1.0;
    _descriTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    _placeholder =[[UILabel alloc] initWithFrame:CGRectMake(_descriTextView.frame.origin.x+2, _descriTextView.frame.origin.y+10, 120, 12) ];
    _placeholder.text =@"说点什么吧";
    _placeholder.backgroundColor = [UIColor clearColor];
    _bgImages =[[UIView alloc] initWithFrame:CGRectMake(0,_descriTextView.frame.size.height+_descriTextView.frame.origin.y+20, _bgScrollView.frame.size.width, 80)];
    _bgImages.layer.borderWidth =1.0;
   
    //[_bgImages.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage.png"]] CGColor]];
    //_bgImages.backgroundColor = [UIColor grayColor];
    _save =[[UIView alloc] initWithFrame:CGRectMake(5, _bgImages.frame.origin.y+_bgImages.frame.size.height+20, _bgScrollView.frame.size.width-10, 40)];
    _save.backgroundColor = [UIColor blueColor];
    UILabel *pSave = [[UILabel alloc] initWithFrame:_save.frame];
    pSave.textAlignment = NSTextAlignmentCenter;
    pSave.textColor = [UIColor whiteColor];
    pSave.text = @"保存到草稿箱";

    _placeholder.enabled = NO;
     //_bgScrollView.backgroundColor =[UIColor grayColor];
    [_bgScrollView addSubview:_wallImage];
    [_bgScrollView addSubview:_bgsesciLabel];
    [_bgScrollView addSubview:_titleTextField];
    [_bgScrollView addSubview:_descriTextView];
    [_bgScrollView addSubview:_placeholder];
    [_bgScrollView addSubview:_bgImages];
    [_bgScrollView addSubview:_save];
    [_bgScrollView addSubview:pSave];
    
    [self.view addSubview:_bgScrollView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
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
   // imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
    
}

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
    
    NLViewController *pic = [[NLViewController alloc] initWithNibName:@"NLViewController" bundle:nil];
    pic.bgImage = image;
    pic.Nl_delegate =self;
    [self.navigationController pushViewController:pic  animated:NO];
 //需要以模态的形式展示
    //[self performSelector:@selector(saveImage:) withObject:image];
    
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
    if(_wallImage.image == nil)
    _wallImage.image= image;
   _bgsesciLabel.hidden =YES;
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(65+arc4random_uniform(26))];
    }
    for(int i=0;i<8;i++){
        [fileName appendFormat:@"%c",(97+arc4random_uniform(26))];
    }
    [_images addObject:image];
    [_imageNames addObject:fileName];
    

}
-(void)changeiamge:(UIImage*)image{
    _wallImage.image = image;
    NSLog(@"changeIamge");
};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
