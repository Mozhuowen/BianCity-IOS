//
//  ErrCode.m
//  biancity
//
//  Created by 朱云 on 15/5/29.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "ErrCode.h"

@implementation ErrCode
+(NSString *)errcode:(int)idx{
     switch(idx){
         case 100:
         return @"帐号在其他地方登录，请退出后重新登录";
         case 101:return @"用户名已经存在";
         case 103:return @"用户名不存在";
         case 105:return @"用户不能存在";
         case 106:return @"边城名已经存在";
         case 107:return @"token错误，请退出后重新登录";
         case 108: return @"签名错误";
         case 201: return @"服务器错误";
         default:return @"未知错误";
     }
};
@end
