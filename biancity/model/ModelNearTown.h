//
//  ModelNearTown.h
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoInfo.h"
#import "basicRequest.h"
@interface ModelNearTown : basicRequest
@property (nonatomic,strong) NSMutableArray<Optional>* rejectid;
@property (nonatomic,strong) GeoInfo *geo;
@end
