//
//  responseApplyTown.h
//  biancity
//
//  Created by 朱云 on 15/5/8.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelAppleTown.h"
@interface responseApplyTown : ModelAppleTown
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@end
