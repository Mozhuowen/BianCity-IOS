//
//  ApplyTown.h
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoInfo.h"
#import "basicRequest.h"
@protocol ApplyTown
@end
@interface ApplyTown : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* townid;
@property (nonatomic,strong) NSString<Optional>* townname;
@property (nonatomic,strong) NSString<Optional>* descri;
@property (nonatomic,strong) NSString<Optional>* cover;
@property (nonatomic,strong) NSString<Optional>* createtime;
@property (nonatomic,strong) NSNumber<Optional>* subscriptions;
@property (nonatomic,strong) GeoInfo* geoinfo;
@property (nonatomic,strong) NSNumber<Optional>* good;
@property (nonatomic)  BOOL dosubscri;
@property (nonatomic,strong) NSNumber<Optional>* userid;
@property (nonatomic,strong) NSString<Optional>* username;
@property (nonatomic,strong) NSString<Optional>* usercover;
@property (nonatomic,strong) NSNumber<Optional>* storycount;
@end
