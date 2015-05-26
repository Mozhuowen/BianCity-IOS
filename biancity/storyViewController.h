//
//  storyViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/13.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TownStory.h"
#import "UIImageView+WebCache.h"
#import "ImgScrollView.h"
#import "TapImageView.h"
@interface storyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SDWebImageManagerDelegate,TapImageViewDelegate,ImgScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) TownStory * story;
@property (nonatomic) BOOL isComeFromFavorite;
@property (nonatomic) BOOL notEditFlag;
@end
