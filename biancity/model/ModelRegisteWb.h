//
//  ModelRegisteWb.h
//  biancity
//
//  Created by 朱云 on 15/5/24.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol ModelRegisteWb
@end
@interface ModelRegisteWb : JSONModel
/** 用户UID（int64） */
@property (nonatomic,strong) NSString<Optional>*  id;
/** 字符串型的用户 UID */
@property (nonatomic,strong) NSString<Optional>*  idstr;
/** 用户昵称 */
@property (nonatomic,strong) NSString<Optional>*  screen_name;
/** 友好显示名称 */
@property (nonatomic,strong) NSString<Optional>*  name;
/** 用户所在省级ID */
@property  (nonatomic,strong) NSNumber<Optional>* province;
/** 用户所在城市ID */
@property  (nonatomic,strong) NSNumber<Optional>* city;
/** 用户所在地 */
@property (nonatomic,strong) NSString<Optional>*  location;
/** 用户个人描述 */
@property (nonatomic,strong) NSString<Optional>*  descri;
/** 用户博客地址 */
@property (nonatomic,strong) NSString<Optional>*  url;
/** 用户头像地址，50×50像素 */
@property (nonatomic,strong) NSString<Optional>*  profile_image_url;
/** 用户的微博统一URL地址 */
@property (nonatomic,strong) NSString<Optional>*  profile_url;
/** 用户的个性化域名 */
@property (nonatomic,strong) NSString<Optional>*  domain;
/** 用户的微号 */
@property (nonatomic,strong) NSString<Optional>*  weihao;
/** 性别，m：男、f：女、n：未知 */
@property (nonatomic,strong) NSString<Optional>*  gender;
/** 粉丝数 */
@property  (nonatomic,strong) NSNumber<Optional>* followers_count;
/** 关注数 */
@property  (nonatomic,strong) NSNumber<Optional>* friends_count;
/** 微博数 */
@property  (nonatomic,strong) NSNumber<Optional>* statuses_count;
/** 收藏数 */
@property  (nonatomic,strong) NSNumber<Optional>* favourites_count;
/** 用户创建（注册）时间 */
@property (nonatomic,strong) NSString<Optional>*  created_at;
/** 是否允许所有人给我发私信，true：是，false：否 */
@property  (nonatomic,strong) NSNumber<Optional>* allow_all_act_msg;
/** 是否允许标识用户的地理位置，true：是，false：否 */
@property  (nonatomic,strong) NSNumber<Optional>* geo_enabled;
/** 是否是微博认证用户，即加V用户，true：是，false：否 */
@property  (nonatomic,strong) NSNumber<Optional>* verified;
/** 用户备注信息，只有在查询用户关系时才返回此字段 */
@property (nonatomic,strong) NSString<Optional>*  remark;
/** 是否允许所有人对我的微博进行评论，true：是，false：否 */
@property  (nonatomic,strong) NSNumber<Optional>* allow_all_comment;
/** 用户大头像地址 */
@property (nonatomic,strong) NSString<Optional>*  avatar_large;
/** 用户高清大头像地址 */
@property (nonatomic,strong) NSString<Optional>*  avatar_hd;
/** 认证原因 */
@property (nonatomic,strong) NSString<Optional>*  verified_reason;
/** 该用户是否关注当前登录用户，true：是，false：否 */
@property  (nonatomic,strong) NSNumber<Optional>* follow_me;
/** 用户的在线状态，0：不在线、1：在线 */
@property  (nonatomic,strong) NSNumber<Optional>* online_status;
/** 用户的互粉数 */
@property  (nonatomic,strong) NSNumber<Optional>* bi_followers_count;
@end
