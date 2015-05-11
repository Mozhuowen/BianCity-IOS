//
//  ModelGood.h
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "basicRequest.h"

@interface ModelGood : basicRequest
/**被赞对象类型0-town 1-story 2-comment 3-message*/
@property (nonatomic,strong) NSNumber<Optional>* type;
/**0-加赞 1-减赞*/
@property (nonatomic,strong) NSNumber<Optional>* action;
/**赞总数*/
@property (nonatomic,strong) NSNumber<Optional>* goods;
/**对数据模型的id*/
@property (nonatomic,strong) NSNumber<Optional>* targetid;
/**是否为赞状态*/
@property (nonatomic) BOOL dogood;
@end
