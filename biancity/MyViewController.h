//
//  MyViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MyCollectionReusableView.h"
#import "MyCollectionReusableView.h"
#import "HotTownCollectionViewCell.h"
#import "ResponseHotTown.h"
#import "ResponseUser.h"
#import "Refresh.h"
#import "MsgEncrypt.h"
#import "AFHTTPRequestOperationManager.h"
#import "locationViewController.h"
#import "showNavigationController.h"
#import "settingTableViewController.h"
#import "showNavigationController.h"
#import "townViewController.h"
#import "responseApplyTown.h"
#import "SDProgressView.h"
#import "SDDemoItemView.h"
#import "NLViewController.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import <CommonCrypto/CommonDigest.h>
@interface MyViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,SDWebImageManagerDelegate,TapImageViewDelegate,NLImagepickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) ResponseUser * User;
@property (strong,nonatomic) NSMutableArray *fakeColors;
@property (nonatomic,strong) ModelUser *requestUser;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) responseApplyTown *applyTown;
@property (nonatomic,strong)  showNavigationController *show;


@end
