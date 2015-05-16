//
//  ModelComment.h
//  biancity
//
//  Created by 朱云 on 15/5/14.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
@protocol ModelComment
@end
@interface ModelComment : basicRequest
@property (nonatomic,strong) NSNumber<Optional>* townid;	//边城id
@property (nonatomic,strong) NSNumber<Optional>* putaoid;	//故事id
@property (nonatomic,strong) NSString<Optional>* content;	//评论内容
@property (nonatomic,strong) NSString<Optional>*  username;	//评论者用户名
@property (nonatomic,strong) NSString<Optional>*  cover;	//评论者头像
@property (nonatomic,strong) NSString<Optional>*  time;	//评论时间
@property (nonatomic,strong) NSNumber<Optional>*  goods;		//评论获赞数
@property (nonatomic,strong) NSNumber<Optional>*  dogood;	//当前用户是否点赞，原为boolean
@property (nonatomic,strong) NSNumber<Optional>* commentid;	//评论id
@property (nonatomic,strong) NSNumber<Optional>* commentposition;	//获取下一条评论开始的位置,第一次获取为0,第二次获取为15,依次类推
@property (nonatomic,strong) NSNumber<Optional>*  userid;		//评论者id
@end
