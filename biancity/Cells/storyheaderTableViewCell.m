//
//  storyheaderTableViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/13.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "storyheaderTableViewCell.h"

@implementation storyheaderTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 
    if(self!=nil){
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*3/5)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _bgImageView.frame.origin.y+_bgImageView.frame.size.height-25, _bgImageView.frame.size.width, 25)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        UIView *bg = [[UIView alloc] initWithFrame:_titleLabel.frame];
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = 0.4;
        _iconUserImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, _bgImageView.frame.origin.y+_bgImageView.frame.size.height+10, 30, 30)];
        _iconUserImage.layer.masksToBounds = YES;
        _iconUserImage.layer.cornerRadius = 15.0;
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconUserImage.frame.origin.x+_iconUserImage.frame.size.width+4, _iconUserImage.frame.origin.y, 120, 15)];
        _userNameLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.origin.y+_userNameLabel.frame.size.height, 120, 15)];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _subscrilabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-130, _userNameLabel.frame.origin.y, 60, 25)];
        _subscrilabel.font = [UIFont systemFontOfSize:16];
        _subscrilabel.textAlignment = NSTextAlignmentCenter;
        _subscrilabel.layer.borderWidth = 1.0;
        _subscrilabel.layer.cornerRadius = 3.0;
        _subscrilabel.layer.borderColor = [[UIColor grayColor] CGColor];
        _goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subscrilabel.frame.origin.x+70, _subscrilabel.frame.origin.y, 36, 25)];
        _goodLabel.textAlignment = NSTextAlignmentRight;
        _goodLabel.font = [UIFont systemFontOfSize:14];
        _iconGoodImage = [[UIImageView alloc] initWithFrame:CGRectMake(_goodLabel.frame.origin.x+_goodLabel.frame.size.width, _goodLabel.frame.origin.y-2, 25, 25)];
        _descrilabel = [[UILabel alloc] initWithFrame:CGRectMake(4, _iconUserImage.frame.origin.y+_iconUserImage.frame.size.height+25, [UIScreen mainScreen].bounds.size.width-8, 100)];
        _descrilabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descrilabel.numberOfLines = 0;
        _descrilabel.font = [UIFont systemFontOfSize:14];
        _imagesView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _descrilabel.frame.origin.y+_descrilabel.frame.size.height+2, [UIScreen mainScreen].bounds.size.width, 1)];
        _comment = [[UILabel alloc] initWithFrame:CGRectMake(4, _imagesView.frame.origin.y+_imagesView.frame.size.height+15, 50, 30)];
        _comment.textAlignment = NSTextAlignmentCenter;
        _comment.font = [UIFont systemFontOfSize:16];
        _comment.textColor = [UIColor whiteColor];
        _comment.layer.cornerRadius =4.0;
          _comment.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_bgImageView];
           [self.contentView addSubview:bg];
        [self.contentView addSubview:_titleLabel];
         [self.contentView addSubview:_iconUserImage];
         [self.contentView addSubview:_userNameLabel];
         [self.contentView addSubview:_dateLabel];
         [self.contentView addSubview:_subscrilabel];
         [self.contentView addSubview:_goodLabel];
         [self.contentView addSubview:_iconGoodImage];
         [self.contentView addSubview:_descrilabel];
        [self.contentView addSubview:_imagesView];
         [self.contentView addSubview:_comment];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
