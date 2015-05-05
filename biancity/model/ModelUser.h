//
//  ModelUser.h
//  biancity
//
//  Created by 朱云 on 15/5/5.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ApplyTown.h"
@interface ModelUser : JSONModel
@property (nonatomic,strong) NSString<Optional>* name;
@property (nonatomic,strong)  NSString<Optional>* cover;
@property (nonatomic,strong)  NSMutableArray<ApplyTown,Optional>* mytowns;
@property (nonatomic,strong)  NSString<Optional>* sex;
@property (nonatomic,strong)  NSString<Optional>* location;
@property (nonatomic,strong)  NSNumber<Optional>* fans;			//粉丝数
@property (nonatomic,strong)  NSNumber<Optional>* subscricount;	//订阅数
@property (nonatomic,strong)  NSNumber<Optional>* favoritecount;	//收藏数
@property (nonatomic,strong)  NSNumber<Optional>* begoodcount;	//被赞数
@property (nonatomic,strong)  NSNumber<Optional>* towncount;		//创建小镇数
@property (nonatomic,strong)  NSNumber<Optional>* putaocount;		//创建葡萄数
@property (nonatomic,strong)  NSNumber<Optional>* userid;			//目标用户的ptuserid
@property (nonatomic)  bool onlystatis;	//是否只获取统计数据
@property (nonatomic,strong)  NSString<Optional>* wallimage;	//墙纸
@end
