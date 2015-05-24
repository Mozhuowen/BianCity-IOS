//
//  ModelAppleTown.h
//  biancity
//
//  Created by 朱云 on 15/5/24.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GeoInfo.h"
#import "JSONModel.h"
@protocol ModelAppleTown
@end
@interface ModelAppleTown : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* townid;
@property (nonatomic,strong) NSString<Optional>* townname;
@property (nonatomic,strong) NSString<Optional>* descri;
@property (nonatomic,strong) NSString<Optional>* cover;
@property (nonatomic,strong) NSString<Optional>* createtime;
@property (nonatomic,strong) NSNumber<Optional>* subscriptions;
@property (nonatomic,strong) GeoInfo<Optional>* geoinfo;
@property (nonatomic,strong) NSNumber<Optional>* good;
@property (nonatomic)  BOOL dosubscri;
@property (nonatomic,strong) NSNumber<Optional>* userid;
@property (nonatomic,strong) NSString<Optional>* username;
@property (nonatomic,strong) NSString<Optional>* usercover;
@property (nonatomic,strong) NSNumber<Optional>* storycount;
@end
