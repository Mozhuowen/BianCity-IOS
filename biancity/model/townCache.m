//
//  townCache.m
//  biancity
//
//  Created by 朱云 on 15/5/20.
//  Copyright (c) 2015年 Zhuyun. All rights reserved.
//

#import "townCache.h"

@implementation townCache
- (NSDictionary *) encodedItem{
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            _coverName,@"coverName",
            _title ,@"title",
            _descri,@"descri",
            _imagesName,@"imagesName",
            _type,@"type",
            [_geoinfo toDictionary],@"geoinfo",
            nil];
}
- (townCache*)decodeItem:(NSDictionary*)source{
    townCache * result = [townCache alloc];
    result.coverName = [source objectForKey:@"coverName"];
    result.title = [source objectForKey:@"title"];
    result.descri = [source objectForKey:@"descri"];
    result.imagesName = [source objectForKey:@"imagesName"];
    result.type = [source objectForKey:@"type"];
    result.geoinfo = [[GeoInfo alloc] initWithDictionary:[source objectForKey:@"geoinfo"] error:nil] ;
    NSLog(@"towncache %@",result);
    return result;
}
@end
