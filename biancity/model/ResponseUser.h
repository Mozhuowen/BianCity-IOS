//
//  ResponseUser.h
//  biancity
//
//  Created by 朱云 on 15/5/5.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ModelUser.h"
@interface ResponseUser : JSONModel
@property (nonatomic) BOOL stat;
@property (nonatomic,strong) NSNumber<Optional>* errcode;
@property (nonatomic,strong) ModelUser<Optional>* user;
@end
