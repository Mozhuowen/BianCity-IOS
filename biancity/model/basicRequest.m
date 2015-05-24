//
//  basicRequest.m
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import "basicRequest.h"
#import "ResponseLogin.h"
@implementation basicRequest
-(id)init{
    self=[super init];
    [self readUserDeafultsOwn:0];
//    self.ptoken = @"jjU1uD4ESLf1fNyXqu6EuFTUrAlzArLF";
//    self.ptoken =@"QQ6I6lN8pc4l1NnxkCyFxrkOmzFqbKZO";
//    self.ptuserid = [[NSNumber alloc] initWithInt:15];
//            NSDictionary *cache = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_INFO];
//        ResponseLogin *tmp = [[ResponseLogin alloc] initWithDictionary:cache error:nil];
//        self.ptoken = tmp.ptoken;
//        self.ptuserid = tmp.ptuserid;
   
    return self;
}
- (void) readUserDeafultsOwn:(NSInteger)check{
    if([[NSUserDefaults standardUserDefaults] dictionaryForKey:LOGIN_INFO]!=nil){
    NSDictionary *cache = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LOGIN_INFO];
    ResponseLogin *tmp = [[ResponseLogin alloc] initWithDictionary:cache error:nil];
    self.ptoken = tmp.ptoken;
        self.ptuserid = tmp.ptuserid;
    }
}
@end
