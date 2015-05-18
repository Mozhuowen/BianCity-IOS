//
//  ModelFavorite.h
//  biancity
//
//  Created by 朱云 on 15/5/18.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
@protocol ModelFavorite
@end
@interface ModelFavorite : basicRequest
@property (nonatomic,strong)NSNumber<Optional>* putaoid;
/**收藏动作 0-收藏 1-取消收藏*/
@property (nonatomic,strong)NSNumber<Optional>* action;
/**当前是否收藏*/
@property (nonatomic) BOOL dofavori;
@end
