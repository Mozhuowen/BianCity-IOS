//
//  PKCS7Encodeing.h
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <Foundation/Foundation.h>
static int bloc_size = 32;
@interface PKCS7Encodeing : NSObject
+(NSData *)encoding:(NSString *)Msg;
@end
