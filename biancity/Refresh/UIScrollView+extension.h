//
//  UIScrollView+extension.h
//  bianCity_version0.1
//
//  Created by 朱云 on 15/4/12.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (extension)
@property (assign, nonatomic) CGFloat refresh_contentInsetTop;
@property (assign, nonatomic) CGFloat refresh_contentInsetBottom;
@property (assign, nonatomic) CGFloat refresh_contentInsetLeft;
@property (assign, nonatomic) CGFloat refresh_contentInsetRight;

@property (assign, nonatomic) CGFloat refresh_contentOffsetX;
@property (assign, nonatomic) CGFloat refresh_contentOffsetY;

@property (assign, nonatomic) CGFloat refresh_contentSizeWidth;
@property (assign, nonatomic) CGFloat refresh_contentSizeHeight;
@end
