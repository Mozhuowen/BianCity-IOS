//
//  ReponseGood.h
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "basicRequest.h"
#import "ModelGood.h"
@interface ResponseGood : basicRequest
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@property (nonatomic,strong) ModelGood<Optional>* good;
@end
