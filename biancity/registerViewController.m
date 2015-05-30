//
//  registerViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/30.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "registerViewController.h"
#import "RequestRegiste.h"
#import "ResponseRegiste.h"
#import "HomeTabBarViewController.h"
#import "ResponseLogin.h"
@interface registerViewController ()
@property (nonatomic,strong) UITextField *UserName;
@property (nonatomic,strong) UITextField *PassWord;
@property (nonatomic,strong) UIButton *Commit;
@property (nonatomic,strong) RequestRegiste * requestRgister;
@property (nonatomic,strong) ResponseRegiste * responseRegister;
@property (nonatomic,strong) ResponseLogin *responseLogin;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectLeftAction:)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
    self.view.frame = [UIScreen mainScreen].bounds;
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.x +=20;
    rect.origin.y +=85;
    rect.size.width -=40;
    rect.size.height = 40;
    _UserName = [[UITextField alloc] initWithFrame:rect];
    _UserName.placeholder = @"用户名";
    _UserName.layer.cornerRadius = 4;
    _UserName.layer.borderWidth =0.5;
    _UserName.layer.masksToBounds =YES;
    _UserName.delegate = self;
    _UserName.returnKeyType =UIReturnKeyDone;
    _UserName.layer.borderColor = [[UIColor colorWithRed:(10*16+8)/255.0 green:(10*16+11)/255.0 blue:(10*16+13)/255.0 alpha:1.0] CGColor];
    rect.origin.y += 65;
    _PassWord = [[UITextField alloc] initWithFrame:rect];
    _PassWord.placeholder =@"密码";
    _PassWord.layer.cornerRadius = 4;
    _PassWord.layer.borderWidth =0.5;
    _PassWord.layer.masksToBounds =YES;
    _PassWord.secureTextEntry = YES;
    _PassWord.delegate =self;
    _PassWord.returnKeyType =UIReturnKeyDone;
    _PassWord.layer.borderColor = [[UIColor colorWithRed:(10*16+8)/255.0 green:(10*16+11)/255.0 blue:(10*16+13)/255.0 alpha:1.0] CGColor];
    rect.origin.y += 65;
    
    _Commit = [[UIButton alloc] initWithFrame:rect];
    _Commit.backgroundColor = [UIColor whiteColor];
    _Commit.layer.borderColor = [[UIColor colorWithRed:(10*16+8)/255.0 green:(10*16+11)/255.0 blue:(10*16+13)/255.0 alpha:1.0] CGColor];
    _Commit.layer.borderWidth =0.5;
    _Commit.layer.masksToBounds =YES;
    _Commit.layer.cornerRadius =15;
    [_Commit setTitle:@"注册" forState:UIControlStateNormal] ;
    [_Commit setTitleColor:[UIColor colorWithRed:(10*16+8)/255.0 green:(10*16+11)/255.0 blue:(10*16+13)/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_Commit addTarget:self action:@selector(commitRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_UserName];
    [self.view addSubview:_PassWord];
    [self.view addSubview:_Commit];
    UITapGestureRecognizer * tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapview];
    _requestRgister = [[RequestRegiste alloc] init];
    _requestRgister.logintype = 2;
    _requestRgister.imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString] ;
    _requestRgister.sv = [[UIDevice currentDevice] systemVersion];
    _requestRgister.phonemodel = [self deviceString];
    _requestRgister.brand = [[UIDevice currentDevice] model];
    // Do any additional setup after loading the view from its nib.
}
-(void)commitRegister:(id)sender{
    if(_UserName.text.length==0||_PassWord.text.length==0){
        PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 40)];               [self.view addSubview:pop];
        if(_PassWord.text.length==0){
            [pop setText:@"密码不能为空"];
        }
        if(_UserName.text.length==0){
            [pop setText:@"用户名不能为空"];
        }
        return;
    }
    _requestRgister.username = _UserName.text;
    _requestRgister.password = _PassWord.text;
    [self loadInfo:0];
}
-(void)tapView{
    [_UserName resignFirstResponder];
    [_PassWord resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    [_UserName resignFirstResponder];
    [_PassWord resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    if(textField.text.length != 0)
    //        _isChange =YES;
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"]||[deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,2"]||[deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"]||[deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,3"]||[deviceString isEqualToString:@"iPhone7,4"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"]||[deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    log(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
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
-(void)loadInfo:(int)check{
    
    NSDictionary *parameters=[_requestRgister toDictionary];
    NSString *url =[NSString stringWithString:registeUrl];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"User Info is %@",info);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _responseRegister = [[ResponseRegiste alloc] initWithDictionary:data error:nil];
        if(!_responseRegister.stat){
            PopView *pop =[[PopView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 40)];               [self.view addSubview:pop];
            [pop setText:@"用户名已存在，请更换用户名"];
            
        }else{
            _responseLogin =[[ResponseLogin alloc] init];
            _responseLogin.ptoken = _responseRegister.ptoken;
            _responseLogin.ptuserid = _responseRegister.ptuserid;
            _responseLogin.name = _responseRegister.name;
            _responseLogin.sex = _responseRegister.sex;
            _responseLogin.cover = _responseRegister.cover;
            _responseLogin.location = _responseRegister.location;
            _responseLogin.needregiste = [NSNumber numberWithBool:YES];
            [self saveUserDefaultsOwn:0 data:[_responseLogin toDictionary]];
            [self saveUserDefaultsOwn:1 data:data];
            [self welcome];
        }
        
        log(@"User stat is %d,errcode is %d,%@",_responseRegister.stat,_responseRegister.errcode,_responseRegister);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log(@"Error: %@", error);
    }];
}

-(void)welcome{
    log(@"Welcome");
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeTabBarViewController *home = [story instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    [self presentViewController:home animated:NO completion:^{} ];
    
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
