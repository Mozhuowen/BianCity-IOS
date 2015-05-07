//
//  locationViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMaPKit/MAMapKit.h"
#import "AMapSearchKit/AMapSearchAPI.h"
#import "GeoInfo.h"
@protocol saveGeoInfodegelate <NSObject>

- (void) setGeoInfo:(GeoInfo*) sender;

@end
@interface locationViewController : UIViewController<MAMapViewDelegate,AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak) id<saveGeoInfodegelate> t_delegate;
@end
