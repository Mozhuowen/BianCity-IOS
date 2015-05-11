//
//  basicRequest.m
//  HotTown
//
//  Created by 朱云 on 15/4/27.
//  Copyright (c) 2015年 朱云. All rights reserved.
//

#import "basicRequest.h"

@implementation basicRequest
-(id)init{
    self=[super init];
   // self.ptoken = @"jjU1uD4ESLf1fNyXqu6EuFTUrAlzArLF";
    self.ptoken =@"QQ6I6lN8pc4l1NnxkCyFxrkOmzFqbKZO";
    self.ptuserid = [[NSNumber alloc] initWithInt:15];
    return self;
}
//+ (id)sharedBaseic {
//    static dispatch_once_t once;
//    static id instance;
//    dispatch_once(&once, ^{
//        instance = [self new];
//    });
//    return instance;
//}
//
//- (id)init {
//    if ((self = [super init])) {
//        self.ptoken = [NSString new];
//        self.rejectid = [NSMutableArray new];
//        self.ptuserid = [NSString new];
//        self.gethoturl = [NSString new];
//    }
//    return self;
//}
@end
