//
//  townViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/7.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "upLoadImageViewController.h"
#import "HotTownCollectionViewCell.h"
@interface townViewController : UIViewController<ApplyTownGeoInfodegelate,SDWebImageManagerDelegate,UITableViewDataSource,UITableViewDelegate>
-(void)setApplyTownGeoInfo:(responseApplyTown *)sender;
@property (nonatomic,strong) responseApplyTown * applyTown;
@property (nonatomic,strong) UIScrollView * bgScrollView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *townNameLabel;
@property (nonatomic,strong) UIImageView *iconGoodImageView;
@property (nonatomic,strong) UILabel *goodslabel;
@property (nonatomic,strong) UILabel *summaryLabel;
@property (nonatomic,strong) UIImageView *userImageView;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *fansLabel;
@property (nonatomic,strong) UIImageView *iconAddrimage;
@property (nonatomic,strong) UILabel* addrLabel;
@property (nonatomic,strong) UIImageView *addrMapImage;
@property (nonatomic,strong) UILabel *subscri;
@property (nonatomic,strong) UILabel *leaveMsgLabel;
@property (nonatomic,strong) UILabel *storyLabel;
@property (nonatomic,strong) UIImageView *iconAddImage;
@property (nonatomic,strong) UIBarButtonItem *leftButton;
@property (nonatomic,strong) UIBarButtonItem *rightButton;
@property (nonatomic,strong) UIImageView *placeholderImage;
@property (nonatomic) BOOL isComeFromSubscri;
@end
