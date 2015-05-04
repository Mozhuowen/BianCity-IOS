//
//  MsgEncrypt.h
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MsgEncrypt : NSObject
-(NSString*)EncryptMsg:(NSString*)Msg timeStmap:(NSString*)time;
-(NSData *)Base64Decoding:(NSString *)key;
-(NSData *)AESEncryptmsg:(NSData *)msg key:(NSData*)akey;
- (NSString*) sha1:(NSData *)Msg;
-(NSString*)EncryptMsg:(NSString*)Msg key:(NSString *)aesKey timeStmap:(NSString*)time;
@end
