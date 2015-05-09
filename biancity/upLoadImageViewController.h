//
//  upLoadImageViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/6.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "saveAddrViewController.h"
#import "responseApplyTown.h"
@protocol ApplyTownGeoInfodegelate <NSObject>
- (void) setApplyTownGeoInfo:(responseApplyTown*) sender;
@end
@interface upLoadImageViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,upLoadGeoInfodegelate>
@property (weak) id<ApplyTownGeoInfodegelate> applyTown_delegate;
@end
