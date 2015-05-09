//
//  HotTownCollectionViewCell.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "HotTownCollectionViewCell.h"

@implementation HotTownCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        self.HotTownCoverImage =[[UIImageView alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.width-8, self.frame.size.width-8)];
        [self addSubview:self.HotTownCoverImage];
        self.hotTownNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(4, (self.HotTownCoverImage.frame.size.height+self.HotTownCoverImage.frame.origin.y+6), 150, 8)];
        [self.hotTownNameLabel setFont:[UIFont fontWithName: @"Helvetica"   size : 12.0]];
        [self addSubview:self.hotTownNameLabel];
        
        self.icon1Image = [[UIImageView alloc] initWithFrame:CGRectMake(4, (self.hotTownNameLabel.frame.size.height+self.hotTownNameLabel.frame.origin.y+10), 12, 12)];
        [self addSubview:self.icon1Image];
        self.addrLabel =[[UILabel alloc] initWithFrame:CGRectMake(18, (self.hotTownNameLabel.frame.size.height+self.hotTownNameLabel.frame.origin.y+14), 105, 8)];
        [self.addrLabel setFont:[UIFont fontWithName: @"Helvetica"   size : 10.0]];
        [self addSubview:self.addrLabel];
        self.goodLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-30,(self.hotTownNameLabel.frame.size.height+self.hotTownNameLabel.frame.origin.y+11), 15, 15)];
         [self.goodLabel setFont:[UIFont fontWithName: @"Helvetica"   size : 10.0]];
        [self addSubview:self.goodLabel];
        self.icon2Image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-24, (self.hotTownNameLabel.frame.size.height+self.hotTownNameLabel.frame.origin.y+10), 16, 16)];
        [self addSubview:self.icon2Image];
    }
    //self.userInteractionEnabled = YES;
    return self;
}
//- (void)transfromInfo:(id)applyTown{
//    
//    if ([self.applyTown_delegate respondsToSelector:@selector(setApplyTownGeoInfo:)])
//    {
//        [self.applyTown_delegate setApplyTownGeoInfo:applyTown];
//    }
//    
//}

@end
