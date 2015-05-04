//
//  NearViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/4.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MAMaPKit/MAMapKit.h"
#import "AMapSearchKit/AMapSearchAPI.h"
@interface NearViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,SDWebImageManagerDelegate,CLLocationManagerDelegate>

@end
