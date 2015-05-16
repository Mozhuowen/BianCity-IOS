//
//  ResponseComment.h
//  biancity
//
//  Created by 朱云 on 15/5/15.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelComment.h"
#import "JSONModel.h"
@interface ResponseComment : JSONModel
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@property (nonatomic,strong) NSMutableArray<ModelComment,Optional>* comments;
@end
