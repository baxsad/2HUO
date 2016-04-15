//
//  GDRouterCenter.m
//  2HUO
//
//  Created by iURCoder on 4/14/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDRouterCenter.h"
#import "GDRouterReger.h"
#import "GDModel.h"

#define DN_REGEX_PARAMS_SUFFIX @"(\\?[\\w- .&=]+)$"
#define DN_REGEX_PARAMS_UNIT @"([\\w- ]+)(=)([\\w- ]+)$"

@implementation GDRouterAction

@end

@interface GDRouterCenter()

@property (nonatomic, strong)NSMutableDictionary *pathActionMapping;
@property (nonatomic, strong)NSMutableDictionary *pathTargetMapping;

@end

@implementation GDRouterCenter

+ (instancetype)defaultCenter
{
    static GDRouterCenter *defaultCenter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultCenter = [[self.class alloc]init];
        defaultCenter.pathTargetMapping =
        (NSMutableDictionary *)[GDRouterReger targetMap];
        defaultCenter.pathActionMapping =
        (NSMutableDictionary *)[GDRouterReger actionMap];
    });
    
    return defaultCenter;
}

- (GDRouterAction *)actionOfPath:(NSString *)path
{
    NSString *clearPath = [self clearPath:path];
    if (!clearPath) {
        return nil;
    }
    
    NSArray *subPath = [clearPath componentsSeparatedByString:@"/"];
    if (subPath.count<2) return nil;
    
    NSString * targetKey = subPath[0];
    NSString * actionKey = subPath[1];
    
    NSString * targetString = self.pathTargetMapping[targetKey];
    NSString * actionString = self.pathActionMapping[actionKey];
    
    // 如果没有mapped就取url
    if (!targetString) {
        Class classFromUrl = NSClassFromString(targetKey);
        if (classFromUrl) targetString = targetKey;
    }
    
    // 如果没有mapped就取url
    if (!actionString) {
        SEL actionFromUrl = NSSelectorFromString(actionString);
        if (targetString) {
            BOOL canSend = [[[NSClassFromString(targetString) alloc] init] respondsToSelector:actionFromUrl];
            if (canSend) {
                actionString = actionKey;
            }
        }
    }
    
    // 没有mapped并且url中的不可以用就用默认
    if (!targetString) targetString = @"GDRouterDefault";
    if (!actionString) actionString = @"notFound:";
    
    Class target = NSClassFromString(targetString);
    SEL action = NSSelectorFromString(actionString);
    
    NSDictionary *params = [self queryItemsInPath:clearPath];
    
    GDRouterAction *actionObj = [[GDRouterAction alloc] init];
    actionObj.target = target;
    actionObj.action = action;
    actionObj.params = params;
    
    return actionObj;
}

- (NSMutableDictionary *)queryItemsInPath:(NSString *)path
{
    NSMutableDictionary *queryItems = [@{} mutableCopy];
    
    NSRange paramsRange = [path rangeOfString:DN_REGEX_PARAMS_SUFFIX
                                       options:NSRegularExpressionSearch];
    
    
    
    if(paramsRange.location == NSNotFound) return nil;
    
    NSMutableString *mParams = [[path substringWithRange:paramsRange] mutableCopy];
    
    NSMutableString *mPath = [path mutableCopy];
    [mPath deleteCharactersInRange:paramsRange];
    path = mPath;
    
    while (mParams.length > 0) {
        NSRange r = [mParams rangeOfString:DN_REGEX_PARAMS_UNIT
                                   options:NSRegularExpressionSearch];
        
        if(r.location != NSNotFound)
        {
            NSString *matched = [mParams substringWithRange:r];
            NSArray *sliced = [matched componentsSeparatedByString:@"="];
            if(sliced.count == 2)
            {
                NSString *key = [self dn_trimDontCareCharacters:sliced[0]];
                NSString *value = [self dn_trimDontCareCharacters:sliced[1]];
                queryItems[key] = value;
            }
            [mParams deleteCharactersInRange:NSMakeRange(r.location - 1, r.length + 1)];
        }
        else
        {
            mParams = [@"" mutableCopy];
        }
    }
    
    if(queryItems.allKeys.count == 0) return nil;
    
    return [queryItems mutableCopy];
}

- (NSString *)dn_trimDontCareCharacters:(NSString *)c
{
    c = [c stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    c = [c stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&?"]];
    return c;;
}

- (NSString *)clearPath:(NSString *)path
{
    if (!path) return nil;
    if ([path rangeOfString:@"://"].location == NSNotFound)return path;
    NSArray * arr = [path componentsSeparatedByString:@"://"];
    if (arr.count <2) return nil;
    return arr[1];
}

- (BOOL)model:(id)object params:(NSDictionary *)params
{
    if (!params || params == (id)kCFNull) return NO;
    if (![params isKindOfClass:[NSDictionary class]]) return NO;
    
    return [[[GDModel alloc] init] model:object params:params];
    
}

@end
