//
//  basicRequest.h
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface basicRequest : NSObject
@property (nonatomic,strong) NSString* ptoken;	//用户token
@property (nonatomic,strong) NSString* ptuserid;	//用户id
@property (nonatomic,strong) NSMutableArray*  rejectid;  //已显示的边城号
@property (nonatomic,strong) NSString *gethoturl;
-(NSDictionary*)paraters;
//+ (id)sharedBaseic;
@end
