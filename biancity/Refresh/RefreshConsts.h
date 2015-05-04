//
//  RefreshConsts.h
//  bianCity_version0.1
//
//  Created by 朱云 on 15/4/13.
//  Copyright (c) 2015年 朱云. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef bianCity_version0_1_RefreshConsts_h
#define bianCity_version0_1_RefreshConsts_h
#endif


#define textColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define RefreshLabelTextColor textColor(150, 150, 150)

extern NSString *const RefreshBundleName;
#define RefreshSrcName(file) [RefreshBundleName stringByAppendingPathComponent:file]
extern const  CGFloat RefreshViewHeight;
extern const CGFloat RefreshFastAnimationDuration;
extern const CGFloat RefreshSlowAnimationDuration;


extern NSString *const RefreshFooterPullToRefresh;
extern NSString *const RefreshFooterReleaseToRefresh;
extern NSString *const RefreshFooterRefreshing;

extern NSString *const RefreshHeaderPullToRefresh;
extern NSString *const RefreshHeaderReleaseToRefresh;
extern NSString *const RefreshHeaderRefreshing;
extern NSString *const RefreshHeaderTimeKey;

extern NSString *const RefreshContentOffset;
extern NSString *const RefreshContentSize;
