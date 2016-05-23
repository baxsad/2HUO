//
//  OrderListModel.m
//  2HUO
//
//  Created by iURCoder on 5/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


@implementation Order

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end