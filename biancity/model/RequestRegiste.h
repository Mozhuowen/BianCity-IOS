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
@end
