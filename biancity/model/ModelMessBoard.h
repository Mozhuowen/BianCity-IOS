//
//  ModelMessBoard.h
//  biancity
//
//  Created by 朱云 on 15/5/17.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
#import "GeoInfo.h"
@protocol ModelMessBoard
@end
@interface ModelMessBoard : basicRequest
@property (nonatomic,strong) NSNumber<Optional>* townid;		//边城id
@property (nonatomic,strong) NSString<Optional>* content;	//留言内容
@property (nonatomic,strong) NSString<Optional>* username;	//留言作者用户名
@property (nonatomic,strong) NSString<Optional>* cover;	//留言者头像
@property (nonatomic,strong) NSString<Optional>*time;	//留言时间
@property (nonatomic,strong) NSNumber<Optional>*  goods;		//留言获赞数
@property (nonatomic,strong) NSNumber<Optional>* dogood;	//当前用户是否对该留言点赞
@property (nonatomic,strong) NSNumber<Optional>* messid;		//留言id
@property (nonatomic,strong) NSNumber<Optional>* messposition;	//加载下一条留言开始的位置
@property (nonatomic,strong)  GeoInfo<Optional>* geo;	//评论者的地理信息，提交评论时用.
@property (nonatomic,strong) NSNumber<Optional>*  userid;		//评论的用户的id
@end
