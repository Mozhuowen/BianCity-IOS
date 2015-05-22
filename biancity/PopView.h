//
//  PopView.h
//  biancity
//
//  Created by 朱云 on 15/5/22.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView
{
    UILabel         *_textLabel;
    int             _queueCount;
}

- (void) setText:(NSString *) text;


@end
