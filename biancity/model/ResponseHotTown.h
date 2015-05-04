//
//  ResponseHotTown.h
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
#import "ApplyTown.h"
@interface ResponseHotTown : JSONModel
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@property (nonatomic,strong) NSMutableArray<ApplyTown,Optional>* towns;

@end
