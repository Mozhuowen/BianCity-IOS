//
//  CnameViewController.m
//  biancity
//
//  Created by 朱云 on 15/5/24.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "CnameViewController.h"
#import "ModelCName.h"
#import "ResponseSimple.h"
#import "PopView.h"
#import "HomeTabBarViewController.h"
@interface CnameViewController (){

}
@property (weak, nonatomic) IBOutlet UITextField *cnametextField;
@property (nonatomic,strong) ModelCName *requestCName;
@property (nonatomic,strong) ResponseSimple *responseCName;
@end

@implementation CnameViewController

- (IBAction)saveChange:(id)sender {
     [_cnametextField resignFirstResponder];
    if(_cnametextField.text.length>0){
        _requestCName.username = _cnametextField.text;
        [self loadInfo];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cnametextField.returnKeyType =UIReturnKeyDone;
    _requestCName = [[ModelCName alloc] init];
    // Do any additional setup after loading the view from its nib.
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
-(void)loadInfo{
    NSDictionary *parameters;
    NSString *url ;
            parameters = [_requestCName toDictionary];
        url =[NSString stringWithString:cnameUrl];
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
        NSLog(@"data %@",data);
       
        if(!(BOOL)[data objectForKey:@"stat"]){
            PopView *pop =[[PopView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 -100, 80, 200, 320)];
            [self.view addSubview:pop];
            [pop setText:@"名字已经被占用，请改再一个"];
        }else{
            [self welcome];
        }
        
       log(@"responseCName stat is %d",(BOOL)[data objectForKey:@"stat"]);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
