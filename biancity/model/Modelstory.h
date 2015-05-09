//
//  Modelstory.h
//  biancity
//
//  Created by 朱云 on 15/5/9.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
@interface ModelStory : basicRequest
@property (nonatomic) int townid;		//目标边城id
@property (nonatomic) int position;	//开始获取的故事数量,刚开始获取时为0，服务器每次返回15个，下次获取为15，以此类推
@end
