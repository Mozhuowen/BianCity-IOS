//
//  townCache.h
//  biancity
//
//  Created by 朱云 on 15/5/20.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GeoInfo.h"
#import "JSONModel.h"
@interface townCache : JSONModel
@property (nonatomic,strong) NSString<Optional>* coverName;
@property (nonatomic,strong)  NSString<Optional>* title;
@property (nonatomic,strong)  NSString<Optional>* descri;
@property (nonatomic,strong)  NSMutableArray<Optional> *imagesName;
@property (nonatomic)  NSInteger type;//0边城，1故事
@property (nonatomic,strong)  NSNumber<Optional>* townid;
@property (nonatomic,strong) GeoInfo<Optional>* geoinfo;
@property (nonatomic,strong) NSString<Optional>* mapIamgeName;
- (NSDictionary *) encodedItem;
- (townCache*)decodeItem:(NSDictionary*)source;
@end
