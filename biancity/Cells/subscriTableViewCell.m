//
//  subscriTableViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/18.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "subscriTableViewCell.h"

@implementation subscriTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 5, self.frame.size.width, 80);
    if(self != nil){
        _townImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, self.frame.size.height, self.frame.size.height)];
        _townNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_townImage.frame.origin.x+_townImage.frame.size.width+4, 4,_townImage.frame.size.width*3, self.frame.size.height/2-4)];
        _iconAddrImage =[[UIImageView alloc] initWithFrame:CGRectMake(_townNameLabel.frame.origin.x, _townNameLabel.frame.origin.y+_townNameLabel.frame.size.height+12, 20, 20)];
        _townAddrLabel =[[UILabel alloc] initWithFrame:CGRectMake(_townNameLabel.frame.origin.x+20, _townNameLabel.frame.origin.y+_townNameLabel.frame.size.height+4, _townNameLabel.frame.size.width, self.frame.size.height/2-4)];
        [self addSubview:_townImage];
        [self.contentView addSubview:_townNameLabel];
        [self.contentView addSubview:_iconAddrImage];
        [self.contentView addSubview:_townAddrLabel];
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
