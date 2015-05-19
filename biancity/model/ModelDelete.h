//
//  ModelDelete.h
//  biancity
//
//  Created by 朱云 on 15/5/19.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
@interface ModelDelete : basicRequest
/**删除对象类型 0-边城 1-故事*/
@property (nonatomic,strong) NSNumber* type;
/**对应对象的id*/
@property (nonatomic,strong) NSNumber* id;
@end
