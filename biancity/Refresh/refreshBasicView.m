//
//  refreshBasicView.m
//  bianCity_version0.1
//
//  Created by 朱云 on 15/4/13.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import "refreshBasicView.h"
#import "RefreshConsts.h"
#import "UIScrollView+extension.h"
#import "UIView+extension.h"
@interface refreshBasicView()
{
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIActivityIndicatorView *_activityView;
}
@end
@implementation refreshBasicView
/**
 *  状态标签
 */
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = RefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}
/**
 *  箭头图片
 */
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:RefreshSrcName(@"arrow.png")]];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

/**
 *  状态标签
 */
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        activityView.autoresizingMask = self.arrowImage.autoresizingMask;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = RefreshViewHeight;
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.设置默认状态
        self.state = RefreshStateNormal;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.箭头
    CGFloat arrowX = self.refresh_width * 0.5 - 100;
    self.arrowImage.center = CGPointMake(arrowX, self.refresh_height * 0.5);
    
    // 2.指示器
    self.activityView.center = self.arrowImage.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:RefreshContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:RefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.refresh_width = newSuperview.refresh_width;
        // 设置位置
        self.refresh_x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}
- (void)drawRect:(CGRect)rect
{
    if (self.state == RefreshStateWillRefreshing) {
        self.state = RefreshStateRefreshing;
    }
}
- (BOOL)isRefreshing
{
    return RefreshStateRefreshing == self.state;
}
- (void)beginRefreshing
{
    if (self.state == RefreshStateRefreshing) {
        // 回调
//        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
//            msgSend((__bridge void *)(self.beginRefreshingTaget), self.beginRefreshingAction, self);
//        }
        
        if (self.beginRefreshingCallback) {
            self.beginRefreshingCallback();
        }
    } else {
        if (self.window) {
            self.state = RefreshStateRefreshing;
        } else {
            _state = RefreshStateWillRefreshing;
            [super setNeedsDisplay];
        }
    }
}
- (void)endRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = RefreshStateNormal;
    });
}
- (void)setPullToRefreshText:(NSString *)pullToRefreshText
{
    _pullToRefreshText = [pullToRefreshText copy];
    [self settingLabelText];
}
- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText
{
    _releaseToRefreshText = [releaseToRefreshText copy];
    [self settingLabelText];
}
- (void)setRefreshingText:(NSString *)refreshingText
{
    _refreshingText = [refreshingText copy];
    [self settingLabelText];
}
- (void)settingLabelText
{
    switch (self.state) {
        case RefreshStateNormal:
            // 设置文字
            self.statusLabel.text = self.pullToRefreshText;
            break;
        case RefreshStatePulling:
            // 设置文字
            self.statusLabel.text = self.releaseToRefreshText;
            break;
        case RefreshStateRefreshing:
            // 设置文字
            self.statusLabel.text = self.refreshingText;
            break;
        default:
            break;
    }
}

- (void)setState:(RefreshState)state
{
    // 0.存储当前的contentInset
    if (self.state != RefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回(暂时不返回)
    if (self.state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
        case RefreshStateNormal: // 普通状态
        {
            if (self.state == RefreshStateRefreshing) {
                [UIView animateWithDuration:RefreshSlowAnimationDuration * 0.6 animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 停止转圈圈
                    [self.activityView stopAnimating];
                    
                    // 恢复alpha
                    self.activityView.alpha = 1.0;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 再次设置回normal
                    _state = RefreshStatePulling;
                    self.state = RefreshStateNormal;
                });
                // 直接返回
                return;
            } else {
                // 显示箭头
                self.arrowImage.hidden = NO;
                
                // 停止转圈圈
                [self.activityView stopAnimating];
            }
            break;
        }
            
        case RefreshStatePulling:
            break;
            
        case RefreshStateRefreshing:
        {
            // 开始转圈圈
            [self.activityView startAnimating];
            // 隐藏箭头
            self.arrowImage.hidden = YES;
            
            // 回调
//            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
//                objc_msgSend(self.beginRefreshingTaget, self.beginRefreshingAction, self);
//            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
            break;
        }
        default:
            break;
    }
    
    // 3.存储状态
    _state = state;
    
    // 4.设置文字
    [self settingLabelText];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
