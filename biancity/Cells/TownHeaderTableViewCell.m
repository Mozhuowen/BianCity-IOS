//
//  TownHeaderTableViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/26.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "TownHeaderTableViewCell.h"

@implementation TownHeaderTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
   
    _townNameLabel =[[UILabel alloc ] initWithFrame:CGRectMake(4, _bgImageView.frame.origin.y+_bgImageView.frame.size.height+5, 150, 20)];
    _townNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    _goodslabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.size.width-65, _townNameLabel.frame.origin.y+3, 40, 20)];
    _goodslabel.textAlignment = NSTextAlignmentRight;
    _goodslabel.font = [UIFont systemFontOfSize:14];
    _iconGoodImageView =[[UIImageView alloc] initWithFrame:CGRectMake(_bgImageView.frame.size.width-28, _townNameLabel.frame.origin.y, 25, 25)];
  
    _summaryLabel =[[UILabel alloc] initWithFrame:CGRectMake(4, _townNameLabel.frame.origin.y+_townNameLabel.frame.size.height+15, [UIScreen mainScreen].bounds.size.width-10, 5)];
    _summaryLabel.font = [UIFont systemFontOfSize:12];
    _summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _summaryLabel.numberOfLines = 0;
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, _summaryLabel.frame.origin.y+_summaryLabel.frame.size.height+15, 50, 50)];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 25;
    _userImageView.userInteractionEnabled = YES;

    //    _userImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bj" ofType:@"jpg"]];
    
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.frame.origin.x+_userImageView.frame.size.height, _userImageView.frame.origin.y+4, 100, 20)];
    _userNameLabel.font = [UIFont systemFontOfSize:14];
    
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.size.height+_userNameLabel.frame.origin.y+5, 80, 12)];
    _fansLabel.font = [UIFont systemFontOfSize:14];
    
    _iconAddrimage = [[UIImageView alloc] initWithFrame:CGRectMake(-3, _userImageView.frame.origin.y+_userImageView.frame.size.height+15, 20, 20)];
    
  
    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake( _iconAddrimage.frame.origin.x+_iconAddrimage.frame.size.width+2,  _iconAddrimage.frame.origin.y+7, 150, 12)];
    _addrLabel.font = [UIFont systemFontOfSize:14];
    _addrLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _addrLabel.numberOfLines = 0;
    _subscri = [[UILabel alloc ] initWithFrame:CGRectMake(5, _iconAddrimage.frame.origin.y+50, 80, 40)];
    _subscri.layer.borderWidth = 1.0;
    _subscri.layer.cornerRadius = 3.0;
    _subscri.textAlignment =NSTextAlignmentCenter;
    _subscri.layer.borderColor =[[UIColor grayColor] CGColor];
  
    _leaveMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subscri.frame.origin.x+90, _subscri.frame.origin.y, 80, 40)];
    _leaveMsgLabel.layer.borderWidth = 1.0;
    _leaveMsgLabel.layer.cornerRadius = 3.0;
    _leaveMsgLabel.layer.borderColor =[[UIColor grayColor] CGColor];
    _leaveMsgLabel.textAlignment =NSTextAlignmentCenter;
    
    _addrMapImage = [[UIImageView alloc ]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3/5-5,_summaryLabel.frame.origin.y+_summaryLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width*2/5, _leaveMsgLabel.frame.origin.y+_leaveMsgLabel.frame.size.height-(_summaryLabel.frame.origin.y+_summaryLabel.frame.size.height))];
    
    _storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,_leaveMsgLabel.frame.origin.y+80, 80, 35)];
    _storyLabel.textAlignment =NSTextAlignmentCenter;
    _storyLabel.backgroundColor = [UIColor blueColor];
    _storyLabel.textColor = [UIColor whiteColor];
    _iconAddImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width -50, _storyLabel.frame.origin.y-5, 40, 40)];
    [self.contentView addSubview:_bgImageView];
    [self.contentView addSubview:_townNameLabel];
    [self.contentView addSubview:_goodslabel];
    [self.contentView addSubview:_iconGoodImageView];
    [self.contentView addSubview:_summaryLabel];
    [self.contentView addSubview:_userImageView];
    [self.contentView addSubview:_userNameLabel];
    [self.contentView addSubview:_fansLabel];
    [self.contentView addSubview:_iconAddrimage];
    [self.contentView addSubview:_addrLabel];
    
    [self.contentView addSubview:_subscri];
    [self.contentView addSubview:_leaveMsgLabel];
    [self.contentView addSubview:_addrMapImage];
    [self.contentView addSubview:_fansLabel];
    [self.contentView addSubview:_storyLabel];
    [self.contentView addSubview:_iconAddImage];

    return self;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)changeFrame{
    
        _userImageView.frame=CGRectMake(5, _summaryLabel.frame.origin.y+_summaryLabel.frame.size.height+25, 50, 50);
    
        _userNameLabel.frame=CGRectMake(_userImageView.frame.origin.x+_userImageView.frame.size.height+4, _userImageView.frame.origin.y+5, 100, 20);
    
        _fansLabel.frame=CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.size.height+_userNameLabel.frame.origin.y+5, 80, 12);
    
        _iconAddrimage.frame=CGRectMake(0, _userImageView.frame.origin.y+_userImageView.frame.size.height+15, 20, 20);
    
        _addrLabel.frame=CGRectMake( _iconAddrimage.frame.origin.x+_iconAddrimage.frame.size.width+2, _iconAddrimage.frame.origin.y-3, 165, 12);
        //[_addrLabel sizeToFit];
        _addrLabel.lineBreakMode =NSLineBreakByWordWrapping;
        _addrLabel.numberOfLines =0;
        _subscri.frame=CGRectMake(5, _iconAddrimage.frame.origin.y+50, 80, 40);
        _leaveMsgLabel.frame= CGRectMake(_subscri.frame.origin.x+90, _subscri.frame.origin.y, 80, 40);
    
        _addrMapImage.frame=
        CGRectMake(self.frame.size.width*3/5-5,_summaryLabel.frame.origin.y+_summaryLabel.frame.size.height, self.frame.size.width*2/5, _leaveMsgLabel.frame.origin.y+_leaveMsgLabel.frame.size.height-(_summaryLabel.frame.origin.y+_summaryLabel.frame.size.height));
    
        _storyLabel.frame=CGRectMake(4,_leaveMsgLabel.frame.origin.y+60, 80, 35);
    
        _iconAddImage.frame=CGRectMake(self.frame.size.width -45, _storyLabel.frame.origin.y-5, 40, 40);
}


@end
