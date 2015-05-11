//
//  StoryTableViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "StoryTableViewCell.h"
@interface StoryTableViewCell()

@end
@implementation StoryTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, self.frame.size.width, 80);
    if(self != nil){
        _stroyImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, self.frame.size.height, self.frame.size.height)];
        _storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stroyImage.frame.origin.x+_stroyImage.frame.size.width+4, 4,_stroyImage.frame.size.width*3, self.frame.size.height/2-4)];
        _dateLabel =[[UILabel alloc] initWithFrame:CGRectMake(_storyLabel.frame.origin.x, _storyLabel.frame.origin.y+_storyLabel.frame.size.height+4, _storyLabel.frame.size.width*3, self.frame.size.height/2-4)];
        _goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-40, 4, 20, self.frame.size.height/2-4)];
        _iconGoodImage = [[UIImageView alloc] initWithFrame:CGRectMake(_goodLabel.frame.origin.x+12, 12, 20, 20)];
        [self addSubview:_stroyImage];
        [self.contentView addSubview:_storyLabel];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:_goodLabel];
        [self.contentView addSubview:_iconGoodImage];
        
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
