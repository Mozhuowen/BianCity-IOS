//
//  ResponseStory.h
//  biancity
//
//  Created by 朱云 on 15/5/9.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
#import "TownStory.h"
@interface ResponseStory : basicRequest
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@property  NSMutableArray<TownStory,Optional>* putao;
@end
