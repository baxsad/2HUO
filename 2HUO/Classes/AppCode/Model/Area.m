//
//  Area.m
//  2HUO
//
//  Created by iURCoder on 5/11/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "Area.h"

@implementation Areas

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation Area

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"proID":@"provinceId",@"proName":@"provinceNameCH",@"phonetic":@"provinceNameEN"}];
}

@end

@implementation City

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"proID":@"provinceId",@"cityID":@"cityId",@"cityName":@"cityNameCH",@"phoneticName":@"cityNameEN"}];
}

@end
