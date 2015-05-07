//
//  saveAddrViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMaPKit/MAMapKit.h"
#import "AMapSearchKit/AMapSearchAPI.h"
#import "locationViewController.h"
#import "GeoInfo.h"
@interface saveAddrViewController : UIViewController<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,saveGeoInfodegelate>
- (void) setGeoInfo:(GeoInfo*) sender;
@end
