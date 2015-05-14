//
//  TownStory.h
//  biancity
//
//  Created by 朱云 on 15/5/9.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "basicRequest.h"
#import "StoryImage.h"
@protocol TownStory
@end
@interface TownStory : basicRequest
@property (nonatomic,strong) NSNumber<Optional>* userid; 	//故事创建者
@property (nonatomic,strong) NSNumber<Optional>* townid;		//故事所属的边城id
@property (nonatomic,strong) NSNumber<Optional>*  putaoid;	//故事id
@property (nonatomic,strong) NSString<Optional> * title;	//故事标题
@property (nonatomic,strong) NSString<Optional> * content;	//故事内容
@property (nonatomic,strong) NSString<Optional> * cover;	//故事封面
@property (nonatomic,strong) NSString<Optional> * usercover;	//故事创建者头像
@property (nonatomic,strong) NSString<Optional> * username;	//故事创建者用户名
@property (nonatomic,strong) NSString<Optional> * createtime;	//故事创建时间
@property (nonatomic,strong) NSMutableArray<StoryImage,Optional>* images;	//故事包含的图片
@property (nonatomic,strong) NSMutableArray<Optional>* imagenames;	//故事包含的图片名
@property (nonatomic,strong) NSNumber<Optional>* goods;
@end
