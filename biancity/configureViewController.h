//
//  configureViewController.h
//  biancity
//
//  Created by 朱云 on 15/5/19.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelUser.h"
#import "UIImageView+WebCache.h"
@interface configureViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SDWebImageManagerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic,strong) ModelUser* user;
@end
