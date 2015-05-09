//
//  PKCS7Encodeing.m
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import "PKCS7Encodeing.h"

@implementation PKCS7Encodeing
+(NSData *)encoding:(NSString *)Msg{
    NSInteger leng = [Msg dataUsingEncoding:NSUTF8StringEncoding].length;
    int countPad = bloc_size - (leng%bloc_size);
    if (countPad ==0)
        countPad = bloc_size;
    NSMutableData *result =[[NSMutableData alloc] initWithData:[Msg dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *data = [NSString stringWithFormat:@"%c",countPad];
    for(int i =0;i<countPad;i++){
        [result appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return result;
};

@end
