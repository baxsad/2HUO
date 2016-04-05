//
//  YDog.m
//  2HUO
//
//  Created by iURCoder on 4/5/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "YDog.h"
#import <AVOSCloud/AVOSCloud.h>

#define SERVER_ADDRESS @"https://wild-rat-00202.wilddogio.com/"

@interface YDog ()

@property (nonatomic, assign) BOOL          isCooncted;


@end

@implementation YDog

+ (instancetype)shareInstance
{
    static YDog *dog;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dog = [[YDog alloc] init];
    });
    return dog;
}

- (BOOL)isConnect
{
   
    return _isCooncted;
}

- (void)setValue:(id)value inPath:(NSString *)path
{
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:0];
    }
    if ([path hasSuffix:@"/"]) {
        path = [path substringToIndex:path.length-1];
    }
    NSLog(@"path:%@",path);
}

- (id)valueForPath:(NSString *)path
{
    return nil;
}

@end
