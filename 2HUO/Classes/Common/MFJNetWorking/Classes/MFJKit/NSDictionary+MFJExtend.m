//
//  NSDictionary+MFJExtend.m
//  2HUO
//
//  Created by iURCoder on 4/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "NSDictionary+MFJExtend.h"

@implementation NSDictionary (MFJExtend)

- (NSString *)joinToPath{
    NSMutableArray *array = [NSMutableArray array];
    [self each:^(id key, id value) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [array addObject:str];
    }];
    return [array componentsJoinedByString:@"&"];
}

@end
