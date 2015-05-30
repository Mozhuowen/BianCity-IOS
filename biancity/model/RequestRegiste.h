//
//  RequestRegiste.h
//  biancity
//
//  Created by 朱云 on 15/5/24.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
#import "ModelRegisteQQ.h"
#import "ModelRegisteWb.h"
@interface RequestRegiste : basicRequest
@property (nonatomic) int logintype;
@property (nonatomic,strong) ModelRegisteWb<Optional>* registInfo;
@property (nonatomic,strong)  ModelRegisteQQ<Optional>* registqqInfo;
@property  (nonatomic,strong) NSString<Optional>* username;		//用户名
@property  (nonatomic,strong) NSString<Optional>*  password;		//密码
@property  (nonatomic,strong) NSString<Optional>* imei;	//手机唯一imei号
@property  (nonatomic,strong) NSString<Optional>*  sv;		//系统版本
@property  (nonatomic,strong) NSString<Optional>* phonemodel;	//手机型号
@property  (nonatomic,strong) NSString<Optional>* brand;	//手机品牌
@end
