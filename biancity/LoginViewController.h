//
//  LoginViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/23.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentOpenAPI/TencentOAuth.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "WeiboSDK.h"
@interface LoginViewController : UIViewController<TencentSessionDelegate,WBHttpRequestDelegate>
-(void)wbdidother;
@end
