//
//  ResponseSubscriTown.h
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "basicRequest.h"
#import "ApplyTown.h"
#import "ModelSubscriTown.h"
@interface ResponseSubscriTown : basicRequest
@property (nonatomic) BOOL  stat;
@property (nonatomic) int  errcode;
@property (nonatomic,strong) ModelSubscriTown<Optional>* subscri;
@property (nonatomic,strong) NSMutableArray<ApplyTown,Optional>* towns;
@end
