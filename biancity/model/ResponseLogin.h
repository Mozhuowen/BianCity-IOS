//
//  ResponseLogin.h
//  biancity
//
//  Created by 朱云 on 15/5/23.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ModelAppleTown.h"
@interface ResponseLogin : JSONModel
@property  (nonatomic,strong) NSNumber<Optional>* stat;
@property  (nonatomic,strong) NSNumber<Optional>* needregiste;	//标记此次登录是否需要注册，如果无需注册以下字段将会有值
@property  (nonatomic,strong) NSNumber<Optional>* errcode;
@property  (nonatomic,strong) NSNumber<Optional>* ptuserid;			//此次登录用户的id
@property  (nonatomic,strong) NSString<Optional>* name;			//此次登录用户名
@property  (nonatomic,strong) NSString<Optional>* cover;			//用户头像
@property  (nonatomic,strong) NSString<Optional>* ptoken;			//用户ptoken
@property  (nonatomic,strong) NSNumber<Optional>* logintype;		//登录类型
@property  (nonatomic,strong) NSString<Optional>* uid;				//微博的uid或者qq的openid
@property  (nonatomic,strong) NSMutableArray<ModelAppleTown,Optional>* mytowns;	//该登录用户创建过的边城列表
@property  (nonatomic,strong) NSString<Optional>* sex;				//性别
@property  (nonatomic,strong) NSString<Optional>* location;		//地址
@property  (nonatomic,strong) NSNumber<Optional>* needcname;		//此次登录后是否需要修改用户名，默认使用微博或者qq的用户名，如果在边城服务器中有重名则需要修改

@end
