//
//  ResponseSimple.h
//  biancity
//
//  Created by 朱云 on 15/5/19.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface ResponseSimple : JSONModel
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@end
