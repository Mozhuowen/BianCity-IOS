//
//  basicRequest.h
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "modelConsts.h"
#import "JSONModel.h"
#import "MsgEncrypt.h"
#import "AFHTTPRequestOperationManager.h"
@interface basicRequest : JSONModel
@property (nonatomic,strong) NSString<Optional>* ptoken;	//用户token
@property (nonatomic,strong) NSNumber<Optional>*  ptuserid;	//用户id
//+ (id)sharedBaseic;
@end
