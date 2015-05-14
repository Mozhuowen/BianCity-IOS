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
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/15)];
        _iconUserImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, _bgImageView.frame.origin.y+_bgImageView.frame.size.height+10, 30, 30)];
        _iconUserImage.layer.masksToBounds = YES;
        _iconUserImage.layer.cornerRadius = 15.0;
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconUserImage.frame.origin.x+_iconUserImage.frame.size.width+4, _iconUserImage.frame.origin.y, 120, 15)];
        _userNameLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.origin.y+_userNameLabel.frame.size.height, 120, 15)];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _subscrilabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-130, _userNameLabel.frame.origin.y, 60, 30)];
        _subscrilabel.textAlignment = NSTextAlignmentCenter;
        _subscrilabel.layer.borderWidth = 1.0;
        _subscrilabel.layer.borderColor = [[UIColor grayColor] CGColor];
        _goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subscrilabel.frame.origin.x+60, _subscrilabel.frame.origin.y, 30, 30)];
        _goodLabel.textAlignment = NSTextAlignmentRight;
        _iconGoodImage = [[UIImageView alloc] initWithFrame:CGRectMake(_goodLabel.frame.origin.x+_goodLabel.frame.size.width, _goodLabel.frame.origin.y, 30, 30)];
        _descrilabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconUserImage.frame.origin.x, _iconUserImage.frame.origin.y+_iconUserImage.frame.size.height+15, [UIScreen mainScreen].bounds.size.width-20, 20)];
        _descrilabel.contentMode = NSLineBreakByWordWrapping;
        _descrilabel.clipsToBounds = 0;
        _imagesView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _descrilabel.frame.origin.y+24, [UIScreen mainScreen].bounds.size.width, 1)];
        [self.contentView addSubview:_bgImageView];
         [self.contentView addSubview:_iconUserImage];
         [self.contentView addSubview:_userNameLabel];
         [self.contentView addSubview:_dateLabel];
         [self.contentView addSubview:_subscrilabel];
         [self.contentView addSubview:_goodLabel];
         [self.contentView addSubview:_iconGoodImage];
         [self.contentView addSubview:_descrilabel];
        [self.contentView addSubview:_imagesView];
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
