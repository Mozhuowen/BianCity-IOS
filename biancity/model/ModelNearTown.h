//
//  ModelNearTown.h
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "GeoInfo.h"
@interface ModelNearTown : JSONModel
@property (nonatomic,strong) NSArray<Optional>* rejectid;
@property (nonatomic,strong) GeoInfo *geo;
@property (nonatomic,strong) NSString * ptoken;
@property (nonatomic,strong) NSString * ptuserid;
@end
