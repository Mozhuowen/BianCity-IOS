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
        self.myNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-10, 32, 30, 12)];
        [self.myCoverImage addSubview:self.myNameLabel];
        self.iconMyImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-25, 60, 50, 50)];
        [self.myCoverImage addSubview:self.iconMyImage];
        self.iconMaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-45, 120, 18, 20)];
        [self.myCoverImage addSubview:self.iconMaleImage];
         self.maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-25, 126, 18, 8)];
        [self.myCoverImage addSubview:self.maleLabel];
        self.iconLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2-0.5, 105, 1, 50)];
        [self.myCoverImage addSubview:self.iconLineImage];
        
        self.iconAddrImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2+8, 120, 20, 20)];
        [self.myCoverImage addSubview:self.iconAddrImage];
        self.addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myCoverImage.frame.size.width/2+25, 126, 50, 8)];
        [self.myCoverImage addSubview:self.addrLabel];
#pragma end coverImage
        float wt = self.frame.size.width/7;
        float ht = 30.0;
        self.myTownView = [[UIView alloc] initWithFrame:CGRectMake(0, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.myTownView];
        self.myTownsLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 6, wt-2, ht/2-2)];
        [self.myTownView addSubview:self.myTownsLabel];
        self.myTownLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ht+2, wt-2, ht/2-4)];
        [self.myTownView addSubview:self.myTownLabel];
        
        self.myStoryView = [[UIView alloc] initWithFrame:CGRectMake(wt, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.myStoryView];
        self.myStorysLabel= [[UILabel alloc] initWithFrame:CGRectMake(17, 6, wt-2, ht/2-2)];
        [self.myStoryView addSubview:self.myStorysLabel];
        self.myStoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ht+2, wt-2, ht/2-4)];
        [self.myStoryView addSubview:self.myStoryLabel];
        
        
        self.fanView = [[UIView alloc] initWithFrame:CGRectMake(wt*2, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.fanView];
        self.fansLabel= [[UILabel alloc] initWithFrame:CGRectMake(17, 6, wt-2, ht/2-2)];
        [self.fanView addSubview:self.fansLabel];
        self.fanLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ht+2, wt-2, ht/2-4)];
        [self.fanView addSubview:self.fanLabel];
        
        UIView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(wt*3, self.myCoverImage.frame.size.height, wt, ht)];
        self.iconAddImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, wt>ht?wt:ht, wt>ht?wt:ht)];
        [addImage addSubview:self.iconAddImage];
        [self addSubview:addImage];
        
        
        self.checkView = [[UIView alloc] initWithFrame:CGRectMake(wt*4, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.checkView];
        self.checksLabel= [[UILabel alloc] initWithFrame:CGRectMake(17, 6, wt-2, ht/2-2)];
        [self.checkView addSubview:self.checksLabel];
        self.checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ht+2, wt-2, ht/2-4)];
        [self.checkView addSubview:self.checkLabel];
        
        self.storeView = [[UIView alloc] initWithFrame:CGRectMake(wt*5, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.storeView];
        self.storesLabel= [[UILabel alloc] initWithFrame:CGRectMake(17, 6, wt-2, ht/2-2)];
        [self.storeView addSubview:self.storesLabel];
        self.storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ht+2, wt-2, ht/2-4)];
        [self.storeView addSubview:self.storeLabel];
        
        self.goodView = [[UIView alloc] initWithFrame:CGRectMake(wt*6, self.myCoverImage.frame.size.height, wt, ht)];
        [self addSubview:self.goodView];
        self.goodsLabel= [[UILabel alloc] initWithFrame:CGRectMake(17, 6, wt-2, ht/2-2)];
        [self.goodView addSubview:self.goodsLabel];
        self.goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, ht+2, wt-2, ht/2-4)];
        [self.goodView addSubview:self.goodLabel];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
