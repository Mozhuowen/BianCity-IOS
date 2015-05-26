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
@interface townViewController : UIViewController<ApplyTownGeoInfodegelate,SDWebImageManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
-(void)setApplyTownGeoInfo:(responseApplyTown *)sender;
@property (nonatomic,strong) responseApplyTown * applyTown;
@property (nonatomic,strong) UIBarButtonItem *leftButton;
@property (nonatomic,strong) UIBarButtonItem *rightButton;
@property (nonatomic,strong) UIImageView *placeholderImage;
@property (nonatomic) BOOL isComeFromSubscri;
@property (nonatomic) BOOL isComefromUPload;
@property (nonatomic) BOOL notEditFlag;
@end
