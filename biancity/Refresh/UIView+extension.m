//
//  UIView+extension.m
//  bianCity_version0.1
//
//  Created by 朱云 on 15/4/12.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import "UIView+extension.h"

@implementation UIView (extension)
- (void)setRefresh_x:(CGFloat)refresh_x
{
    CGRect frame = self.frame;
    frame.origin.x = refresh_x;
    self.frame = frame;
}

- (CGFloat)refresh_x
{
    return self.frame.origin.x;
}

- (void)setRefresh_y:(CGFloat)refresh_y
{
    CGRect frame = self.frame;
    frame.origin.y = refresh_y;
    self.frame = frame;
}

- (CGFloat)refresh_y
{
    return self.frame.origin.y;
}

- (void)setRefresh_width:(CGFloat)refresh_width
{
    CGRect frame = self.frame;
    frame.size.width = refresh_width;
    self.frame = frame;
}

- (CGFloat)refresh_width
{
    return self.frame.size.width;
}

- (void)setRefresh_height:(CGFloat)refresh_height
{
    CGRect frame = self.frame;
    frame.size.height = refresh_height;
    self.frame = frame;
}

- (CGFloat)refresh_height
{
    return self.frame.size.height;
}

- (void)setRefresh_size:(CGSize)refresh_size
{
    CGRect frame = self.frame;
    frame.size = refresh_size;
    self.frame = frame;
}

- (CGSize)refresh_size
{
    return self.frame.size;
}

- (void)setRefresh_origin:(CGPoint)refresh_origin
{
    CGRect frame = self.frame;
    frame.origin = refresh_origin;
    self.frame = frame;
}

- (CGPoint)refresh_origin
{
    return self.frame.origin;
}

@end
