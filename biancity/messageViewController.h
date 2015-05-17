//
//  messageViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/17.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MAMaPKit/MAMapKit.h"
#import "AMapSearchKit/AMapSearchAPI.h"
@interface messageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SDWebImageManagerDelegate,MAMapViewDelegate,AMapSearchDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) UITableView *messageTableView;
@property (nonatomic,strong) NSNumber *townid;
@property (nonatomic,strong) CLLocation *townLocal;
@end
