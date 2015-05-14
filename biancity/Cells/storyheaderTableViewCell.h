//
//  storyheaderTableViewCell.h
//  biancity
//
//  Created by 朱云 on 15/5/13.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface storyheaderTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * bgImageView;
@property (nonatomic,strong) UIImageView *iconUserImage;
@property (nonatomic,strong) UILabel * userNameLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UILabel * subscrilabel;
@property (nonatomic,strong) UILabel * goodLabel;
@property (nonatomic,strong) UIImageView * iconGoodImage;
@property (nonatomic,strong) UILabel *descrilabel;
@property (nonatomic,strong) UIView * imagesView;
@end
