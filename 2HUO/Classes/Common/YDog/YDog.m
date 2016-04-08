//
//  YDog.m
//  2HUO
//
//  Created by iURCoder on 4/5/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "YDog.h"


#define SERVER_ADDRESS @"https://wild-rat-00202.wilddogio.com/"

@interface YDog ()

@end

@implementation YDog

+ (instancetype)dog
{
    return [[self alloc] init];
}

+ (instancetype)shareInstance
{
    static YDog *dog;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dog = [[YDog alloc] init];
    });
    return dog;
}

- (void)insertInto:(NSString *)table values:(NSDictionary *)values option:(NSDictionary *)option complete:(SaveObjectComplete)complete
{
    NSAssert(values, @"values is empty");
    
    AVObject *obj = [[AVObject alloc] initWithClassName:table];
    
    if ([values isKindOfClass:[NSDictionary class]]||[values isKindOfClass:[NSMutableDictionary class]]) {
        for (NSString * ikey in values) {
            id ivalue = values[ikey];
            ivalue = ivalue == nil ? @"" : ivalue;
            [obj setObject:ivalue forKey:ikey];
        }
    }else{
        @throw [NSException exceptionWithName:@"保存数据失败"
                                       reason:@"对象不是字典格式！"
                                     userInfo:nil];
        return;
    }
    
    if (complete) {
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            complete(succeeded,error);
        }];
    }else{
        [obj saveInBackground];
    }
    
}

- (void)insertInto:(NSString *)table values:(NSDictionary *)values complete:(SaveObjectComplete)complete
{
    [self insertInto:table values:values option:nil complete:complete];
}

- (void)insertInto:(NSString *)table values:(NSDictionary *)values
{
    [self insertInto:table values:values complete:nil];
}


- (void)select:(NSString *)sql complete:(FindObjectComplete)complete
{
    
    [AVQuery doCloudQueryInBackgroundWithCQL:sql callback:^(AVCloudQueryResult *result, NSError *error)
     {
         if (complete) {
             complete(result.results,error);
         }
     }];
}

- (void)selectFrom:(NSString *)table type:(SearchType)type where:(NSString *)key is:(id)value page:(NSString *)page complete:(FindObjectComplete)complete
{
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [value stringValue];
    }
    AVQuery *query = [AVQuery queryWithClassName:table];
    if (key && value && ![key isEqualToString:@""] && ![value isEqualToString:@""]) {
        switch (type) {
            case SearchTypeEqualTo:
            {
                [query whereKey:key equalTo:value];
            }
                break;
            case SearchTypeNotEqualTo:
            {
                [query whereKey:key notEqualTo:value];
            }
                break;
            case SearchTypeGreaterThan:
            {
                [query whereKey:key greaterThan:[value numberValue]];
            }
                break;
            case SearchTypeGreaterThanOrEqualTo:
            {
                [query whereKey:key greaterThanOrEqualTo:[value numberValue]];
            }
                break;
            case SearchTypeLessThan:
            {
                [query whereKey:key lessThan:[value numberValue]];
            }
                break;
            case SearchTypeLessThanOrEqualTo:
            {
                [query whereKey:key lessThanOrEqualTo:[value numberValue]];
            }
                break;
            case SearchTypeMatchesRegex:
            {
                [query whereKey:key matchesRegex:value];
            }
                break;
            case SearchTypeContains:
            {
                [query whereKey:key containsString:value];
            }
                break;
            case SearchTypeNotContains:
            {
                [query whereKey:@"title" matchesRegex:[NSString stringWithFormat:@"^((?!%@).)*$",value]];
            }
                break;
            case SearchTypeHasPrefix:
            {
                [query whereKey:key hasPrefix:value];
            }
                break;
            case SearchTypeHasSuffix:
            {
                [query whereKey:key hasSuffix:value];
            }
                break;
            case SearchTypeArrayContainsArray:
            {
                [query whereKey:key containsAllObjectsInArray:value];
            }
                break;
            case SearchTypeOr:
            {
                NSMutableArray * queryArray = [NSMutableArray array];
                for (NSString * ikey in value) {
                    AVQuery *subQuery = [AVQuery queryWithClassName:table];
                    [self makeQuery:subQuery key:ikey value:value[ikey]];
                    [queryArray addObject:subQuery];
                }
                query = [AVQuery orQueryWithSubqueries:queryArray];
            }
                break;
            case SearchTypeAnd:
            {
                NSMutableArray * queryArray = [NSMutableArray array];
                for (NSString * ikey in value) {
                    AVQuery *subQuery = [AVQuery queryWithClassName:table];
                    [self makeQuery:subQuery key:ikey value:value[ikey]];
                    [queryArray addObject:subQuery];
                }
                query = [AVQuery andQueryWithSubqueries:queryArray];
            }
                break;
                
            case SearchTypeNone:
            
                break;
                
            default:
                break;
        }
    }
    
    [query orderByAscending:@"createdAt"];
    
    if (page) {
        query.limit = 20; // 最多返回 10 条结果
        query.skip = ([page integerValue]-1)*20;
    }
    
    __block AVQuery *weakQuery = query;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray<AVObject *> *response = objects;
        if (complete) {
            if (response) {
                NSMutableArray * data = [NSMutableArray array];
                for (AVObject * obj in response) {
                    [data addObject:obj.dictionaryForObject];
                }
                complete(data,error);
            }
        }
        weakQuery = nil;
    }];
    
}

- (void)deleteFrom:(NSString *)table type:(SearchType)type where:(NSString *)key is:(id)value complete:(DeleteObjectCallBack)complete
{
    AVQuery *query = [AVQuery queryWithClassName:table];
    if (key && value && ![key isEqualToString:@""] && ![value isEqualToString:@""]) {
        switch (type) {
            case SearchTypeEqualTo:
            {
                [query whereKey:key equalTo:value];
            }
                break;
            case SearchTypeNotEqualTo:
            {
                [query whereKey:key notEqualTo:value];
            }
                break;
            case SearchTypeGreaterThan:
            {
                [query whereKey:key greaterThan:[value numberValue]];
            }
                break;
            case SearchTypeGreaterThanOrEqualTo:
            {
                [query whereKey:key greaterThanOrEqualTo:[value numberValue]];
            }
                break;
            case SearchTypeLessThan:
            {
                [query whereKey:key lessThan:[value numberValue]];
            }
                break;
            case SearchTypeLessThanOrEqualTo:
            {
                [query whereKey:key lessThanOrEqualTo:[value numberValue]];
            }
                break;
            case SearchTypeMatchesRegex:
            {
                [query whereKey:key matchesRegex:value];
            }
                break;
            case SearchTypeContains:
            {
                [query whereKey:key containsString:value];
            }
                break;
            case SearchTypeNotContains:
            {
                [query whereKey:@"title" matchesRegex:[NSString stringWithFormat:@"^((?!%@).)*$",value]];
            }
                break;
            case SearchTypeHasPrefix:
            {
                [query whereKey:key hasPrefix:value];
            }
                break;
            case SearchTypeHasSuffix:
            {
                [query whereKey:key hasSuffix:value];
            }
                break;
            case SearchTypeArrayContainsArray:
            {
                [query whereKey:key containsAllObjectsInArray:value];
            }
                break;
            case SearchTypeOr:
            {
                NSMutableArray * queryArray = [NSMutableArray array];
                for (NSString * ikey in value) {
                    AVQuery *subQuery = [AVQuery queryWithClassName:table];
                    [self makeQuery:subQuery key:ikey value:value[ikey]];
                    [queryArray addObject:subQuery];
                }
                query = [AVQuery orQueryWithSubqueries:queryArray];
            }
                break;
            case SearchTypeAnd:
            {
                NSMutableArray * queryArray = [NSMutableArray array];
                for (NSString * ikey in value) {
                    AVQuery *subQuery = [AVQuery queryWithClassName:table];
                    [self makeQuery:subQuery key:ikey value:value[ikey]];
                    [queryArray addObject:subQuery];
                }
                query = [AVQuery andQueryWithSubqueries:queryArray];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    __block AVQuery *weakQuery = query;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray<AVObject *> *response = objects;
        if (complete) {
            if (response) {
                
                for (AVObject * obj in response) {
                    [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        complete(obj,succeeded,error);                    }];
                }
                
            }else{
                complete(nil,NO,error);
            }
        }
        weakQuery = nil;
    }];
}

- (void)makeQuery:(AVQuery *)query key:(NSString *)key value:(id)value
{
    if ([value hasPrefix:@"=="]) {
        [query whereKey:key equalTo:[value substringFromIndex:1]];
    }
    if ([value hasPrefix:@">"]) {
        [query whereKey:key greaterThan:[value substringFromIndex:0]];
    }
    if ([value hasPrefix:@">="]) {
        [query whereKey:key greaterThanOrEqualTo:[value substringFromIndex:1]];
    }
    if ([value hasPrefix:@"<"]) {
        [query whereKey:key lessThan:[value substringFromIndex:0]];
    }
    if ([value hasPrefix:@"<="]) {
        [query whereKey:key lessThanOrEqualTo:[value substringFromIndex:1]];
    }
}

- (void)update:(NSString *)table values:(NSDictionary *)values where:(NSString *)key equeTo:(NSString *)value complete:(SaveObjectComplete)complete
{
    AVQuery *query = [AVQuery queryWithClassName:table];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray<AVObject *> *response = objects;
        for (AVObject *obj in response) {
            id serverValue = obj[key];
            if ([serverValue isKindOfClass:[NSNumber class]]) {
                serverValue = [serverValue stringValue];
            }
            if ([serverValue isEqualToString:value]) {
                
                for (NSString * ikey in values) {
                    [obj setObject:values[ikey] forKey:ikey];
                }
                [obj saveInBackgroundWithBlock:complete];
                
            }
        }
    }];
}

@end
