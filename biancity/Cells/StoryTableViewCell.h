//
//  StoryTableViewCell.h
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *stroyImage;
@property (nonatomic,strong) UILabel * storyLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UIImageView *iconGoodImage;
@property (nonatomic,strong) UILabel * goodLabel;
@end
