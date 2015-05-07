//
//  GeoInfo.h
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//
#import "basicRequest.h"
#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GeoInfo : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* longitude;
@property (nonatomic,strong) NSNumber<Optional>* latitude;
@property (nonatomic,strong) NSString<Optional>* address;
@property (nonatomic,strong) NSString<Optional>* country;
@property (nonatomic,strong) NSString<Optional>* province;
@property (nonatomic,strong) NSString<Optional>* city;
@property (nonatomic,strong) NSString<Optional>* district;
@property (nonatomic,strong) NSString<Optional>* citycode;
@property (nonatomic,strong) NSNumber<Optional>* accuracy;//精确度
@property (nonatomic,strong) NSString<Optional>* street;
@property (nonatomic,strong) NSString<Optional>* road;
@property (nonatomic,strong) NSString<Optional>* freeaddr;
@property (nonatomic,strong) NSString<Optional>* screenpng;
@end
