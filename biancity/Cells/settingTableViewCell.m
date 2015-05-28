//
//  settingTableViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/9.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "settingTableViewCell.h"

@implementation settingTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.imageView.frame =CGRectMake(0, 0, 40, 40);//
    _iconImage= [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
   self.imageView.layer.masksToBounds = YES;
  self.imageView.layer.cornerRadius = 20;
    [self.contentView addSubview:_iconImage];
    return  self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
