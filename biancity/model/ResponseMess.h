//
//  ResponseMess.h
//  biancity
//
//  Created by 朱云 on 15/5/17.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
#import "ModelMessBoard.h"
#import "JSONModel.h"
@interface ResponseMess : JSONModel
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@property (nonatomic,strong) NSMutableArray<ModelMessBoard,Optional>* mess;
@end
