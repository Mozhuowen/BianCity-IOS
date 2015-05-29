//
//  AppDelegate.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "AppDelegate.h"
#import "MsgEncrypt.h"
#import "basicRequest.h"

#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#define kAppKey         @"2562644072"
@interface AppDelegate ()
{
    CLLocationManager * localManager;
}

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SDWebImageManager sharedManager].imageDownloader.username = @"httpwatch";
    [SDWebImageManager sharedManager].imageDownloader.password = @"httpwatch01";
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage Demo" forHTTPHeaderField:@"AppName"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
     MsgEncrypt *encrypt = [[MsgEncrypt alloc] init];
    NSString *Str = @"中国abc" ;
          NSString *signature= [encrypt EncryptMsg:Str timeStmap:@"123456"];
    log(@"singature is %@",signature);
    [UIApplication sharedApplication].idleTimerDisabled=TRUE;
    
    localManager = [[CLLocationManager alloc]init];
    //[localManager requestAlwaysAuthorization];
    //[localManager requestWhenInUseAuthorization];
    localManager.delegate =self;
   
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//全局禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSString *myImgUrl = [url absoluteString];
    NSString *jap = @"wb";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(foundObj.length>0) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else {
        return [TencentOAuth HandleOpenURL:url];
    }

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   
    if ([[url scheme] isEqualToString:@"awen"]) {
        log(@"外部调用成功");
    }
    NSString *myImgUrl = [url absoluteString];
    NSString *jap = @"wb";
    NSRange foundObj=[myImgUrl rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(foundObj.length>0) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else {
        return [TencentOAuth HandleOpenURL:url];
    }

}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        _wbexpirationDate = [(WBAuthorizeResponse *)response expirationDate];
        
        if(_wbexpirationDate==nil || _wbCurrentUserID==nil||_wbtoken==nil)
            return;
        
        LoginViewController* login = (LoginViewController*)[self appRootViewController];
        [login wbdidother];
        
    }

}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
@end
