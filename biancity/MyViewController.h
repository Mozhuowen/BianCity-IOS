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
@interface MyViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,SDWebImageManagerDelegate,TapImageViewDelegate>

@end
