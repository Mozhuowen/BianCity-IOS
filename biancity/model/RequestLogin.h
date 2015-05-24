//
//  RequestLogin.h
//  biancity
//
//  Created by 朱云 on 15/5/23.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol RequestLogin
@end
@interface RequestLogin : JSONModel
/**登录类型，0微博 1QQ 2微信*/
@property  (nonatomic,strong) NSNumber<Optional>*  logintype;
@property  (nonatomic,strong) NSString<Optional>* uid;	//微博是uid,qq是openid
@property  (nonatomic,strong) NSString<Optional>* token;
@property  (nonatomic,strong) NSNumber<Optional>*  expire;
@property  (nonatomic,strong) NSString<Optional>* imei;	//手机唯一imei号
@property  (nonatomic,strong) NSString<Optional>* sv;		//系统版本
@property  (nonatomic,strong) NSString<Optional>* phonemodel;	//手机型号
@property  (nonatomic,strong) NSString<Optional>* brand;	//手机品牌
@end
