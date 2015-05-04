//
//  refreshBasicView.h
//  bianCity_version0.1
//
//  Created by 朱云 on 15/4/13.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    RefreshStatePulling=1,// 下拉放开
    RefreshStateNormal = 2,// 正常状态
    RefreshStateRefreshing = 3,// 刷新
    RefreshStateWillRefreshing = 4//将要刷新
} RefreshState;
@interface refreshBasicView : UIView
@property (weak,nonatomic,readonly) UIScrollView *scrollView;
@property (assign,nonatomic,readonly) UIEdgeInsets scrollViewOriginalInset;

@property (weak,nonatomic,readonly)UILabel *statusLabel;
@property (weak,nonatomic,readonly)UIImageView *arrowImage;
@property (weak,nonatomic,readonly)UIActivityIndicatorView *activityView;

@property (nonatomic,copy) void (^beginRefreshingCallback)();
@property (nonatomic,readonly,getter=isRefreshing) BOOL refreshing;
-(void)beginRefreshing;
-(void)endRefreshing;

@property (nonatomic,assign) RefreshState state;
@property (copy,nonatomic) NSString *pullToRefreshText;
@property (copy,nonatomic) NSString *releaseToRefreshText;
@property (copy,nonatomic) NSString *refreshingText;
@end
