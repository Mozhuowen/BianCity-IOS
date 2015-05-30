//
//  ResponseRegiste.h
//  biancity
//
//  Created by 朱云 on 15/5/23.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ModelAppleTown.h"
@interface ResponseRegiste : JSONModel
@property  (nonatomic) BOOL stat;
@property  (nonatomic)  BOOL needchangename; //此次注册后是否需要修改用户名，默认使用微博或者qq的用户名，如果在边城服务器中有重名则需要修改
@property  (nonatomic) int errcode;
@property  (nonatomic,strong) NSString<Optional>* name;
@property  (nonatomic,strong) NSString<Optional>* cover;
@property  (nonatomic,strong) NSString<Optional>* uid;
@property  (nonatomic,strong) NSMutableArray<ModelAppleTown,Optional>* mytowns;
@property  (nonatomic,strong) NSString<Optional>* sex;
@property  (nonatomic,strong) NSString<Optional>* location;
@property  (nonatomic,strong) NSNumber<Optional>* ptuserid;	//注册边城帐号时需要用到这两个
@property  (nonatomic,strong) NSString<Optional>* ptoken;	//注册边城帐号时需要用到这两个
@end
