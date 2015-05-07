//
//  upLoadImageViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "upLoadImageViewController.h"

@interface upLoadImageViewController ()
@property (nonatomic,strong) UIButton * imageButton;
@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UIImageView *iconAddrImage;
@property (nonatomic,strong) UILabel *addrLabel;
@property (nonatomic,strong) UITextField *townNameTextFiled;
@property (nonatomic,strong) UITextView *summaryTextView;
@property (nonatomic,strong) UIButton* saveButton;
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
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(40,70,self.view.frame.size.width-80,self.view.frame.size.width-80)];
    _imageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_imageButton setTitle: @"点击选择封面照片" forState:UIControlStateNormal];
    _imageButton.titleLabel.textColor = [UIColor grayColor];
    [_imageButton.layer setBorderWidth:1.0];
    [_imageButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, _imageButton.frame.origin.y+_imageButton.frame.size.height+5, 70, 12)];
    _msgLabel.text =@"地址信息";
    _msgLabel.textColor =[UIColor grayColor];
    _iconAddrImage = [[UIImageView alloc] initWithFrame:CGRectMake(_msgLabel.frame.origin.x+_msgLabel.frame.size.width+2,  _imageButton.frame.origin.y+_imageButton.frame.size.height, 20, 20)];
    _iconAddrImage.image = [UIImage imageNamed:@"ic_location_large"];
    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconAddrImage.frame.origin.x+22,  _imageButton.frame.origin.y+_imageButton.frame.size.height+5, self.view.frame.size.width-(_iconAddrImage.frame.origin.x+22)-10, 12)];
    _addrLabel.text= @"地址";
    _townNameTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(4,  _imageButton.frame.origin.y+_imageButton.frame.size.height+32, self.view.frame.size.width-8, 20)];
    _townNameTextFiled.placeholder = @"边城名字";
    _townNameTextFiled.delegate =self;
    _townNameTextFiled.returnKeyType =UIReturnKeyDone;
    _townNameTextFiled.borderStyle = UITextBorderStyleLine;
    _summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(4, _townNameTextFiled.frame.origin.y+30, self.view.frame.size.width-8, 80)];
    _summaryTextView.layer.borderWidth = 1.0;
    _summaryTextView.layer.borderColor =[[UIColor grayColor] CGColor];
    _summaryTextView.returnKeyType =UIReturnKeyDone;
    _summaryTextView.delegate = self;
    _summaryTextView.scrollEnabled =YES;
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-80, _summaryTextView.frame.origin.y+100, 160, 40)];
    _saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _saveButton.layer.borderColor =[[UIColor blackColor] CGColor];
    _saveButton.layer.borderWidth = 1.0;
    _saveButton.backgroundColor = [UIColor blueColor];
   [self.view addSubview:_imageButton];
    [self.view addSubview:_msgLabel];
    [self.view addSubview:_iconAddrImage];
     [self.view addSubview:_addrLabel];
    [self.view addSubview:_townNameTextFiled];
    [self.view addSubview:_summaryTextView];
    [self.view addSubview:_saveButton];
    // Do any additional setup after loading the view from its nib.
}
-(void)selectLeftAction:(id)sender{
    [_summaryTextView resignFirstResponder];
    [_townNameTextFiled resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
-(void)selectRightAction:(id)sender{
    [_summaryTextView resignFirstResponder];
    [_townNameTextFiled resignFirstResponder];
    [self.navigationController pushViewController:nil  animated:NO];
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;    
    
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
