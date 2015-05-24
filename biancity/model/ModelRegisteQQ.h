//
//  ModelRegisteQQ.h
//  biancity
//
//  Created by 朱云 on 15/5/23.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
@protocol ModelRegisteQQ
@end
@interface ModelRegisteQQ : basicRequest
@property  (nonatomic,strong) NSString<Optional>* openid;
@property  (nonatomic,strong) NSString<Optional>* is_yellow_year_vip;
@property  (nonatomic,strong) NSNumber<Optional>* ret;
@property  (nonatomic,strong) NSString<Optional>* figureurl_qq_1;
@property  (nonatomic,strong) NSString<Optional>* figureurl_qq_2;
/**昵称*/
@property  (nonatomic,strong) NSString<Optional>* nickname;
@property  (nonatomic,strong) NSString<Optional>* yellow_vip_level;
@property  (nonatomic,strong) NSNumber<Optional>*  is_lost;
@property  (nonatomic,strong) NSString<Optional>* msg;
/**所在城市*/
@property  (nonatomic,strong) NSString<Optional>* city;
@property  (nonatomic,strong) NSString<Optional>* figureurl_1;
@property  (nonatomic,strong) NSString<Optional>* vip;
@property  (nonatomic,strong) NSString<Optional>* level;
@property  (nonatomic,strong) NSString<Optional>* figureurl_2;
@property  (nonatomic,strong) NSString<Optional>* province;
@property  (nonatomic,strong) NSString<Optional>* is_yellow_vip;
/**性别*/
@property  (nonatomic,strong) NSString<Optional>* gender;
@property  (nonatomic,strong) NSString<Optional>* figureurl;
@end
