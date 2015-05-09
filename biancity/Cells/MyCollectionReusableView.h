//
//  MyCollectionReusableView.h
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TapImageViewDelegate <NSObject>

- (void) tappedWithObject:(id) sender;
- (void) setting:(id) sender;
@end
@interface MyCollectionReusableView : UICollectionReusableView
@property (weak) id<TapImageViewDelegate> t_delegate;
@property (nonatomic, strong) id identifier;
@property (strong, nonatomic)  UIImageView *myCoverImage;
@property (strong, nonatomic)  UILabel *myNameLabel;
@property (strong, nonatomic)  UILabel *maleLabel;
@property (strong, nonatomic)  UILabel *addrLabel;
@property (strong, nonatomic)  UIImageView *iconSettingImage;
@property (strong, nonatomic)  UIImageView *iconMyImage;
@property (strong, nonatomic)  UIImageView *iconAddImage;
@property (strong, nonatomic)  UIImageView *iconMaleImage;
@property (strong, nonatomic)  UIImageView *iconAddrImage;
@property (strong, nonatomic)  UIImageView *iconLineImage;

@property (strong, nonatomic)  UILabel *myTownsLabel;
@property (strong, nonatomic)  UILabel *myTownLabel;
@property (strong, nonatomic)  UIView *myTownView;

@property (strong, nonatomic)  UILabel *myStorysLabel;
@property (strong, nonatomic)  UILabel *myStoryLabel;
@property (strong, nonatomic)  UIView *myStoryView;

@property (strong, nonatomic)  UILabel *fansLabel;
@property (strong, nonatomic)  UILabel *fanLabel;
@property (strong, nonatomic)  UIView *fanView;

@property (strong, nonatomic)  UILabel *checksLabel;
@property (strong, nonatomic)  UILabel *checkLabel;
@property (strong, nonatomic)  UIView *checkView;

@property (strong, nonatomic)  UILabel *storesLabel;
@property (strong, nonatomic)  UILabel *storeLabel;
@property (strong, nonatomic)  UIView *storeView;

@property (strong, nonatomic)  UILabel *goodsLabel;
@property (strong, nonatomic)  UILabel *goodLabel;
@property (strong, nonatomic)  UIView *goodView;
@end
