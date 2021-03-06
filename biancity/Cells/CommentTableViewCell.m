//
//  CommentTableViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/15.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self!=nil){
        _iconUserImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 40, 40)];
        _iconUserImage.clipsToBounds = YES;
        _iconUserImage.layer.cornerRadius = 20;
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconUserImage.frame.origin.x+_iconUserImage.frame.size.width+4, _iconUserImage.frame.origin.y+8, 120, 15)];
        _userNameLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.origin.y+_userNameLabel.frame.size.height, 160, 15)];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _goodLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, _userNameLabel.frame.origin.y, 36, 30)];
        _goodLabel.textAlignment = NSTextAlignmentRight;
        _goodLabel.font = [UIFont systemFontOfSize:14];
        _iconGoodImage = [[UIImageView alloc] initWithFrame:CGRectMake(_goodLabel.frame.origin.x+_goodLabel.frame.size.width, _goodLabel.frame.origin.y, 25, 25)];
          _commentRTlabel = [[RTLabel alloc] initWithFrame:CGRectMake(_iconUserImage.frame.origin.x+40, _iconUserImage.frame.origin.y+_iconUserImage.frame.size.height, [UIScreen mainScreen].bounds.size.width-45, 10)];
        	[_commentRTlabel setBackgroundColor:[UIColor clearColor]];
         [_commentRTlabel setParagraphReplacement:@""];
        _commentlabel = [[UILabel alloc] initWithFrame:_commentRTlabel.frame];       _commentlabel.numberOfLines = 0;
        _commentlabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_iconUserImage];
        [self.contentView addSubview:_userNameLabel];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:_goodLabel];
        [self.contentView addSubview:_iconGoodImage];
        [self.contentView addSubview:_commentlabel];
         [self.contentView addSubview:_commentRTlabel];
        // [self.contentView addSubview:_commentWebView];
    }
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
