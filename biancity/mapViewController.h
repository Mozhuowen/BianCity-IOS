//
//  mapViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/18.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMaPKit/MAMapKit.h"
@interface mapViewController : UIViewController<MAMapViewDelegate>
@property (nonatomic,strong) CLLocation *townLocal;
@property (nonatomic,strong) NSString* townname;
@end
