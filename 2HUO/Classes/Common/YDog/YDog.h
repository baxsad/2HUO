//
//  YDog.h
//  2HUO
//
//  Created by iURCoder on 4/5/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypeEqualTo     = 0 ,
    SearchTypeNotEqualTo    = 1 ,
    SearchTypeGreaterThan    = 2 ,
    SearchTypeGreaterThanOrEqualTo     = 3 ,
    SearchTypeLessThan   = 4 ,
    SearchTypeLessThanOrEqualTo = 5,
    SearchTypeMatchesRegex = 6,
    SearchTypeContains = 7,
    SearchTypeNotContains = 8,
    SearchTypeHasPrefix = 9,
    SearchTypeHasSuffix = 10,
    SearchTypeArrayContainsArray = 11,
    SearchTypeOr = 12,
    SearchTypeAnd = 13
};

typedef void (^YDogSaveObjectComplete)(BOOL succeeded, NSError *error);

typedef void (^FindObjectComplete)(NSArray *objects, NSError *error);

typedef void (^DeleteObjectCallBack)(AVObject *object, BOOL succeeded, NSError *error);

@interface YDog : NSObject

+ (instancetype)shareInstance;

- (void)insertInto:(NSString *)table values:(NSDictionary *)values option:(NSDictionary *)option complete:(YDogSaveObjectComplete)complete;

- (void)insertInto:(NSString *)table values:(NSDictionary *)values complete:(YDogSaveObjectComplete)complete;

- (void)insertInto:(NSString *)table values:(NSDictionary *)values;

- (void)select:(NSString *)sql complete:(FindObjectComplete)complete;


- (void)selectFrom:(NSString *)table type:(SearchType)type where:(NSString *)key is:(id)value page:(NSString *)page complete:(FindObjectComplete)complete;

- (void)deleteFrom:(NSString *)table type:(SearchType)type where:(NSString *)key is:(id)value complete:(DeleteObjectCallBack)complete;


- (void)update:(NSString *)table values:(NSDictionary *)values where:(NSString *)key equeTo:(NSString *)value complete:(YDogSaveObjectComplete)complete;

@end
