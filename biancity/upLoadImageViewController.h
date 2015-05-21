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
#import "townCache.h"
@protocol ApplyTownGeoInfodegelate <NSObject>
- (void) setApplyTownGeoInfo:(responseApplyTown*) sender;
@end
@interface upLoadImageViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,upLoadGeoInfodegelate>
@property (weak) id<ApplyTownGeoInfodegelate> applyTown_delegate;
-(void)setCacheBegin:(townCache*)cache key:(NSString*)keyid;
@property (nonatomic,strong) NSString* cacheid;
@property (nonatomic) BOOL isComeFromCache;
@end
