//
//  MyCollectionReusableView.m
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "MyCollectionReusableView.h"

@implementation MyCollectionReusableView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        self.myCoverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];
         [self addSubview:self.myCoverImage];
        self.iconSettingImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width-35, 30, 20, 20)];
        [self.myCoverImage addSubview:self.iconSettingImage];
        self.myNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-120, 32, 240, 24)];
        self.myNameLabel.textColor = [UIColor whiteColor];
        self.myNameLabel.textAlignment = NSTextAlignmentCenter;
        self.myNameLabel.font = [UIFont systemFontOfSize:12];
        [self.myCoverImage addSubview:self.myNameLabel];
        self.iconMyImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-25, 60, 50, 50)];
        [self.myCoverImage addSubview:self.iconMyImage];
        self.iconMaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-40, 120, 14, 14)];
        [self.myCoverImage addSubview:self.iconMaleImage];
         self.maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-25, 126, 18, 8)];
         self.maleLabel.textColor = [UIColor whiteColor];
             self.maleLabel.font = [UIFont systemFontOfSize:12];
        [self.myCoverImage addSubview:self.maleLabel];
        self.iconLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-0.5, 115, 1, 35)];
        [self.myCoverImage addSubview:self.iconLineImage];
        
        self.iconAddrImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2+8, 120, 16, 16)];
        [self.myCoverImage addSubview:self.iconAddrImage];
        self.addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2+25, 126, 150, 8)];
         self.addrLabel.textColor = [UIColor whiteColor];
             self.addrLabel.font = [UIFont systemFontOfSize:12];
        [self.myCoverImage addSubview:self.addrLabel];
#pragma end coverImage
        float wt = self.frame.size.width/7;
        float ht = 30.0;
        int fontSize = 14;
        self.myTownView = [[UIView alloc] initWithFrame:CGRectMake(0, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.myTownView];
        self.myTownsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, wt, ht/2)];
        self.myTownsLabel.font = [UIFont systemFontOfSize:fontSize];
       self.myTownsLabel.textAlignment = NSTextAlignmentCenter;
        [self.myTownView addSubview:self.myTownsLabel];
        self.myTownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht, wt, ht/2)];
        self.myTownLabel.font = [UIFont systemFontOfSize:fontSize];
        self.myTownLabel.textAlignment = NSTextAlignmentCenter;
        [self.myTownView addSubview:self.myTownLabel];
        
        self.myStoryView = [[UIView alloc] initWithFrame:CGRectMake(wt, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.myStoryView];
        self.myStorysLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 6, wt, ht/2)];
        [self.myStoryView addSubview:self.myStorysLabel];
        self.myStoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht, wt, ht/2)];
        [self.myStoryView addSubview:self.myStoryLabel];
        self.myStoryLabel.font = [UIFont systemFontOfSize:fontSize];
        self.myStoryLabel.textAlignment = NSTextAlignmentCenter;
        self.myStorysLabel.font = [UIFont systemFontOfSize:fontSize];
        self.myStorysLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self.fanView = [[UIView alloc] initWithFrame:CGRectMake(wt*2, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.fanView];
        self.fansLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 6, wt, ht/2)];
        [self.fanView addSubview:self.fansLabel];
        self.fanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht, wt, ht/2)];
        [self.fanView addSubview:self.fanLabel];
        self.fanLabel.font = [UIFont systemFontOfSize:fontSize];
        self.fanLabel.textAlignment = NSTextAlignmentCenter;
        self.fansLabel.font = [UIFont systemFontOfSize:fontSize];
        self.fansLabel.textAlignment = NSTextAlignmentCenter;

        
        UITapGestureRecognizer *add=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
        
        UIView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(wt*3, self.myCoverImage.frame.size.height, wt, ht)];
        [addImage setUserInteractionEnabled:YES];
        [addImage addGestureRecognizer:add];
        self.iconAddImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, wt>ht?wt-10:ht-10, wt>ht?wt-10:ht-10)];
        [addImage addSubview:self.iconAddImage];
        [self addSubview:addImage];
        
        
        self.checkView = [[UIView alloc] initWithFrame:CGRectMake(wt*4, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.checkView];
        self.checksLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 6, wt, ht/2)];
        [self.checkView addSubview:self.checksLabel];
        self.checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht, wt, ht/2)];
        [self.checkView addSubview:self.checkLabel];
        self.checkLabel.font = [UIFont systemFontOfSize:fontSize];
        self.checkLabel.textAlignment = NSTextAlignmentCenter;
        self.checksLabel.font = [UIFont systemFontOfSize:fontSize];
        self.checksLabel.textAlignment = NSTextAlignmentCenter;
        
        self.storeView = [[UIView alloc] initWithFrame:CGRectMake(wt*5, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.storeView];
        self.storesLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 6, wt, ht/2)];
        [self.storeView addSubview:self.storesLabel];
        self.storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht, wt, ht/2)];
        [self.storeView addSubview:self.storeLabel];
        self.storeLabel.font = [UIFont systemFontOfSize:fontSize];
        self.storeLabel.textAlignment = NSTextAlignmentCenter;
        self.storesLabel.font = [UIFont systemFontOfSize:fontSize];
        self.storesLabel.textAlignment = NSTextAlignmentCenter;
        
        self.goodView = [[UIView alloc] initWithFrame:CGRectMake(wt*6, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.goodView];
        self.goodsLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 6, wt, ht/2)];
        [self.goodView addSubview:self.goodsLabel];
        self.goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht, wt, ht/2)];
        [self.goodView addSubview:self.goodLabel];
        self.goodLabel.font = [UIFont systemFontOfSize:fontSize];
        self.goodLabel.textAlignment = NSTextAlignmentCenter;
        self.goodsLabel.font = [UIFont systemFontOfSize:fontSize];
        self.goodsLabel.textAlignment = NSTextAlignmentCenter;

    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void) Tapped:(UIGestureRecognizer *) gesture
{
    // NSLog(@"tapped");
    if ([self.t_delegate respondsToSelector:@selector(tappedWithObject:)])
    {
        [self.t_delegate tappedWithObject:self.iconAddImage];
    }
}
@end
