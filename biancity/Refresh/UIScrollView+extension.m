//
//  UIScrollView+extension.m
//  bianCity_version0.1
//
//  Created by 朱云 on 15/4/12.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import "UIScrollView+extension.h"

@implementation UIScrollView (extension)

- (void)setRefresh_contentInsetTop:(CGFloat)refresh_contentInsetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = refresh_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)refresh_contentInsetTop
{
    return self.contentInset.top;
}

- (void)setRefresh_contentInsetBottom:(CGFloat)refresh_contentInsetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = refresh_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)refresh_contentInsetBottom
{
    return self.contentInset.bottom;
}

- (void)setRefresh_contentInsetLeft:(CGFloat)refresh_contentInsetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = refresh_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)refresh_contentInsetLeft
{
    return self.contentInset.left;
}

- (void)setRefresh_contentInsetRight:(CGFloat)refresh_contentInsetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = refresh_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)refresh_contentInsetRight
{
    return self.contentInset.right;
}

- (void)setRefresh_contentOffsetX:(CGFloat)refresh_contentOffsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = refresh_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)refresh_contentOffsetX
{
    return self.contentOffset.x;
}

- (void)setRefresh_contentOffsetY:(CGFloat)refresh_contentOffsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = refresh_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)refresh_contentOffsetY
{
    return self.contentOffset.y;
}

- (void)setRefresh_contentSizeWidth:(CGFloat)refresh_contentSizeWidth
{
    CGSize size = self.contentSize;
    size.width = refresh_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)refresh_contentSizeWidth
{
    return self.contentSize.width;
}

- (void)setRefresh_contentSizeHeight:(CGFloat)refresh_contentSizeHeight
{
    CGSize size = self.contentSize;
    size.height = refresh_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)refresh_contentSizeHeight
{
    return self.contentSize.height;
}

@end
