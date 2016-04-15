//
//  MFJRouterCenter.h
//  2HUO
//
//  Created by iURCoder on 4/14/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class MFJAction;

@interface MFJAction : NSObject

@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic) Class target;
@property (nonatomic) SEL action;

@end

@interface MFJRouterCenter : NSObject

@property (nonatomic, copy)NSString *scheme;

+ (instancetype)defaultCenter;

- (MFJAction *)actionOfPath:(NSString *)path;

- (NSMutableDictionary *)queryItemsInPath:(NSString *)path;

- (BOOL)model:(id)object params:(NSDictionary *)params;

@end
