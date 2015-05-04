//
//  UIScrollView+Refresh.m
//  bianCity_version0.1
//
//  Created by 朱云 on 15/4/12.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "RefreshHeaderView.h"
#import "RefreshFooterView.h"
#import <objc/runtime.h>
@interface UIScrollView ()
@property (weak, nonatomic) RefreshHeaderView *header;
//@property (weak, nonatomic) RefreshFooterView *footer;
@end

@implementation UIScrollView (Refresh)
static char RefreshHeaderViewKey;
static char RefreshFooterViewKey;

- (void)setHeader:(RefreshHeaderView *)header {
    [self willChangeValueForKey:@"RefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &RefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"RefreshHeaderViewKey"];
}

- (RefreshHeaderView *)header {
    return objc_getAssociatedObject(self, &RefreshHeaderViewKey);
}

- (void)setFooter:(RefreshFooterView *)footer {
    [self willChangeValueForKey:@"RefreshFooterViewKey"];
    objc_setAssociatedObject(self, &RefreshFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"RefreshFooterViewKey"];
}

- (RefreshFooterView *)footer {
    return objc_getAssociatedObject(self, &RefreshFooterViewKey);
}

#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback
{
    // 1.创建新的header
    if (!self.header) {
        RefreshHeaderView *header = [RefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.beginRefreshingCallback = callback;
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
//- (void)addHeaderWithTarget:(id)target action:(SEL)action
//{
//    // 1.创建新的header
//    if (!self.header) {
//        RefreshHeaderView *header = [RefreshHeaderView header];
//        [self addSubview:header];
//        self.header = header;
//    }
//    
//    // 2.设置目标和回调方法
//    self.header.beginRefreshingTaget = target;
//    self.header.beginRefreshingAction = action;
//}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader
{
    [self.header removeFromSuperview];
    self.header = nil;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing
{
    [self.header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing
{
    [self.header endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setHeaderHidden:(BOOL)hidden
{
    self.header.hidden = hidden;
}

- (BOOL)isHeaderHidden
{
    return self.header.isHidden;
}

- (BOOL)isHeaderRefreshing
{
    return self.header.state == RefreshStateRefreshing;
}

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback
{
    // 1.创建新的footer
    if (!self.footer) {
        RefreshFooterView *footer = [RefreshFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.beginRefreshingCallback = callback;
}

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
//- (void)addFooterWithTarget:(id)target action:(SEL)action
//{
//    // 1.创建新的footer
//    if (!self.footer) {
//        RefreshFooterView *footer = [RefreshFooterView footer];
//        [self addSubview:footer];
//        self.footer = footer;
//    }
//    
//    // 2.设置目标和回调方法
//    self.footer.beginRefreshingTaget = target;
//    self.footer.beginRefreshingAction = action;
//}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter
{
    [self.footer removeFromSuperview];
    self.footer = nil;
}

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing
{
    [self.footer beginRefreshing];
}

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setFooterHidden:(BOOL)hidden
{
    self.footer.hidden = hidden;
}

- (BOOL)isFooterHidden
{
    return self.footer.isHidden;
}

- (BOOL)isFooterRefreshing
{
    return self.footer.state == RefreshStateRefreshing;
}

/**
 *  文字
 */
- (void)setFooterPullToRefreshText:(NSString *)footerPullToRefreshText
{
    self.footer.pullToRefreshText = footerPullToRefreshText;
}

- (NSString *)footerPullToRefreshText
{
    return self.footer.pullToRefreshText;
}

- (void)setFooterReleaseToRefreshText:(NSString *)footerReleaseToRefreshText
{
    self.footer.releaseToRefreshText = footerReleaseToRefreshText;
}

- (NSString *)footerReleaseToRefreshText
{
    return self.footer.releaseToRefreshText;
}

- (void)setFooterRefreshingText:(NSString *)footerRefreshingText
{
    self.footer.refreshingText = footerRefreshingText;
}

- (NSString *)footerRefreshingText
{
    return self.footer.refreshingText;
}

- (void)setHeaderPullToRefreshText:(NSString *)headerPullToRefreshText
{
    self.header.pullToRefreshText = headerPullToRefreshText;
}

- (NSString *)headerPullToRefreshText
{
    return self.header.pullToRefreshText;
}

- (void)setHeaderReleaseToRefreshText:(NSString *)headerReleaseToRefreshText
{
    self.header.releaseToRefreshText = headerReleaseToRefreshText;
}

- (NSString *)headerReleaseToRefreshText
{
    return self.header.releaseToRefreshText;
}

- (void)setHeaderRefreshingText:(NSString *)headerRefreshingText
{
    self.header.refreshingText = headerRefreshingText;
}

- (NSString *)headerRefreshingText
{
    return self.header.refreshingText;
}

@end
