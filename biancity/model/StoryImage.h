//
//  StoryImage.h
//  biancity
//
//  Created by 朱云 on 15/5/9.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol StoryImage
@end
@interface StoryImage : JSONModel
@property (nonatomic,strong) NSString<Optional>* imagename;	//图片名
@property (nonatomic,strong) NSString<Optional>* md5;			//图片md5值
@property (nonatomic,strong) NSNumber<Optional>* size;			//图片大小
@property (nonatomic,strong) NSNumber<Optional>* list_index;		//图片在故事中的序列
@end
