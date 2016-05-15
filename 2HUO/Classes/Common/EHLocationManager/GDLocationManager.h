//
//  GDLocationManager.h
//  2HUO
//
//  Created by iURCoder on 5/11/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDLocationManager;

typedef void(^LocationCallBack)(BOOL sucess,GDLocationManager * manager);

@interface GDLocationManager : NSObject

@property (nonatomic, assign) double longitude; // 经度

@property (nonatomic, assign) double latitude; // 纬度

@property (nonatomic, assign) double altitude; // 海拔

@property (nonatomic,   copy) NSString * province;// 省
@property (nonatomic,   copy) NSString * city;// 市
@property (nonatomic,   copy) NSString * district;// 区

+ (instancetype)manager;

- (void)startUpdatingLocation:(LocationCallBack)callBack;

@end
