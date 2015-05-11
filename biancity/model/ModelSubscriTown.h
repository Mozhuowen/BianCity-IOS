//
//  ModelSubscriTown.h
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "basicRequest.h"

@interface ModelSubscriTown : basicRequest
@property (nonatomic,strong) NSNumber<Optional>* townid;
/**订阅动作 0-订阅 1-取消订阅*/
@property (nonatomic,strong) NSNumber<Optional>* action;
/**订阅总数*/
@property (nonatomic,strong) NSNumber<Optional>*  subscris;
/**是否订阅*/
@property (nonatomic) BOOL dosubscri;
@end
