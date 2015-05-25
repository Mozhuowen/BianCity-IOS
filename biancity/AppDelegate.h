//
//  AppDelegate.h
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "CoreLocation/CLLocationManagerDelegate.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "WeiboSDK.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (nonatomic,strong) NSDate *wbexpirationDate;
@end

