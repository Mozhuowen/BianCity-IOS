//
//  addStoryViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/10.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLViewController.h"
#import "TownStory.h"
#import "townCache.h"
@interface addStoryViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NLImagepickerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) TownStory* townstory;
@property (nonatomic) NSNumber * townid;
@property (nonatomic,strong) NSString * cacheid;
@property (nonatomic) BOOL isComeFormCache;
@end
