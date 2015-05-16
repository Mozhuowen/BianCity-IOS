//
//  CommentTableViewCell.h
//  biancity
//
//  Created by 朱云 on 15/5/15.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *iconUserImage;
@property (nonatomic,strong) UILabel * userNameLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UILabel * goodLabel;
@property (nonatomic,strong) UIImageView * iconGoodImage;
@property (nonatomic,strong) UIWebView *commentlabel;
@end
