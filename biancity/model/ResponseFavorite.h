//
//  ResponseFavorite.h
//  biancity
//
//  Created by 朱云 on 15/5/18.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ModelFavorite.h"
@interface ResponseFavorite : JSONModel
@property (nonatomic) BOOL stat;
@property (nonatomic) int errcode;
@property (nonatomic,strong) ModelFavorite<Optional>* favori;
@end
