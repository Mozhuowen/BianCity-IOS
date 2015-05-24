//
//  LoginViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/23.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "LoginViewController.h"
#import "ModelRegisteQQ.h"
#import "RequestLogin.h"
#import "ResponseLogin.h"
#import "HomeTabBarViewController.h"
#import "sys/utsname.h"
#import "RequestRegiste.h"
#import "ResponseRegiste.h"
#import "ModelCName.h"
#import "ResponseSimple.h"
#import "CnameViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weiboImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qqImageView;
@property (nonatomic,strong) NSArray *permissions;
@property (nonatomic,strong) TencentOAuth* tencentOAuth;
@property (nonatomic,strong) ModelRegisteQQ *registeQQ;
@property (nonatomic,strong) RequestLogin *requsetLogin;
@property (nonatomic,strong) ResponseLogin *responseLogin;
@property (nonatomic,strong) RequestRegiste *requestRegiste;
@property (nonatomic,strong) ResponseRegiste *responseRegiste;
@property (nonatomic,strong) ModelCName *requestCName;
@property (nonatomic,strong) ResponseSimple *responseCname;
@end

@implementation LoginViewController
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
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}
-(void)getUserInfoResponse:(APIResponse *)response{
    
    _registeQQ = [[ModelRegisteQQ alloc] initWithDictionary:response.jsonResponse error:nil];
    _registeQQ.openid = [_tencentOAuth openId];
    _requestRegiste.registqqInfo = _registeQQ;
    _requestRegiste.logintype = 1;
    NSLog(@"qqinfo is %@",_registeQQ);
    [self loadInfo:1];
   }
- (void)tencentDidLogin
{
    
    _requsetLogin.logintype = [NSNumber numberWithInt:1 ];
    _requsetLogin.token = [_tencentOAuth accessToken];
    _requsetLogin.uid = [_tencentOAuth openId];
    NSTimeInterval timet = [[_tencentOAuth expirationDate] timeIntervalSince1970];
    long long int datet = (long long int)timet;
    datet*=1000;
    _requsetLogin.expire =[NSNumber numberWithLongLong:datet];
    _requsetLogin.imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString] ;
    _requsetLogin.sv = [[UIDevice currentDevice] systemVersion];
    _requsetLogin.phonemodel = [self deviceString];
    _requsetLogin.brand = [[UIDevice currentDevice] model];
    NSLog(@"%@",_requsetLogin);
        [self loadInfo:0];
    
  
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}
- (void)tencentDidNotNetWork
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}
-(void)viewWillAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults] dictionaryForKey:LOGIN_INFO]!=nil){
        _qqImageView.hidden=YES;
        _weiboImageView.hidden= YES;
        [UIView animateWithDuration:2.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _titleImageView.alpha -=1;
                         }
                         completion:^(BOOL finished){
                             [self welcome];
                         }
         ];
       
    }else {
        _qqImageView.hidden=NO;
        _weiboImageView.hidden= NO;

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
  

        _requsetLogin = [[RequestLogin alloc] init];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104330483"  andDelegate:self];
    _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    UITapGestureRecognizer *tapQQ= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqregiste)];
    _qqImageView.userInteractionEnabled = YES;
    [_qqImageView addGestureRecognizer:tapQQ];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)qqregiste{
     [_tencentOAuth authorize:_permissions inSafari:NO];
}

#pragma loading Infomation
-(void)loadInfo:(int)check{
    NSDictionary *parameters;
    NSString *url ;
    if(check == 0){
        parameters = [_requsetLogin toDictionary];
        url =[NSString stringWithString:loginUrl];
    }else if(check ==1){
        parameters = [_requestRegiste toDictionary];
        url =[NSString stringWithString:registeUrl];
    }if(check == 2){
        parameters = [_requestCName toDictionary];
        url =[NSString stringWithString:cnameUrl];
    }
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *strtime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSData *msgjson = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSString* info = [[NSString alloc] initWithData:msgjson encoding:NSUTF8StringEncoding];
    log(@"login Info is %@,%ld",info,info.length);
    NSString *signature= [encrypt EncryptMsg:info timeStmap:strtime];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:strtime forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:[signature uppercaseString] forHTTPHeaderField:@"signature"];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
       // NSLog(@"data %@",data);
      if(check ==0){
           //
           // NSLog(@"_responseLogin is %@",_responseLogin);
            if((NSNumber*)[data objectForKey:@"stat"]){
                [self saveUserDefaultsOwn:0 data:data];
            }else{
                NSLog(@"服务器返回错误");
            }
          _responseLogin = [[ResponseLogin alloc] initWithDictionary:data error:nil];
           NSLog(@"_responseLogin is %@",_responseLogin);

          if([_responseLogin.needregiste boolValue]){
              _requestRegiste =[[RequestRegiste alloc] init];
              [_tencentOAuth getUserInfo];
           }else{
               if([_responseLogin.needcname boolValue]){
                   [self changeName];
                   //_requestCName = [[ModelCName alloc] init] ;
               }else{
                   [self welcome];
               }
            
          }
            log(@"_responseLogin stat is %@,errcode is %@",_responseLogin.stat,_responseLogin.errcode);
        }else if(check ==1){
            if((NSNumber*)[data objectForKey:@"stat"]){
                [self saveUserDefaultsOwn:1 data:data];
            }
            _responseRegiste = [[ResponseRegiste alloc] initWithDictionary:data error:nil];
         if(_responseRegiste.needchangename){
             [self changeName]; // _requestCName = [[ModelCName alloc] init] ;
            }else{
                [self welcome];
            }
            log(@"_responseRegiste stat is %d,errcode is %d",_responseRegiste.stat,_responseRegiste.errcode);
        }else if(check ==2){
            _responseCname = [[ResponseSimple alloc] initWithDictionary:data error:nil];
            log(@"_responseCname stat is %d,errcode is %d",_responseCname.stat,_responseCname.errcode);
            if(_responseCname.stat){
                [self welcome];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)welcome{
    NSLog(@"Welcome");
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeTabBarViewController *home = [story instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    [self presentViewController:home animated:NO completion:^{} ];

}
-(void)changeName{
    CnameViewController *cname = [[CnameViewController alloc] initWithNibName:@"CnameViewController" bundle:nil];
    [self presentViewController:cname animated:NO completion:^{}];
}
#pragma end loading Infomation
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
- (void) readUserDeafultsOwn:(NSInteger)check{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache;
    if(check ==0){
    cache = [userDefaults objectForKey:LOGIN_INFO];
    }else if(check ==1){
     cache = [userDefaults objectForKey:REGISTE_INFO];
    }
    
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
