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
@protocol upLoadGeoInfodegelate <NSObject>

- (void) setUploadGeoInfo:(GeoInfo*) sender;
- (void) setUploadImage:(UIImage*) sender;
@end
@interface saveAddrViewController : UIViewController<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,saveGeoInfodegelate,MAAnnotation>
- (void) setGeoInfo:(GeoInfo*) sender;
@property (weak) id<upLoadGeoInfodegelate> t_delegate;
@end
