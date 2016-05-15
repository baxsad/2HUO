//
//  GDLocationManager.m
//  2HUO
//
//  Created by iURCoder on 5/11/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDLocationManager.h"

@interface GDLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager    *locationManager;

@property (nonatomic,   copy) LocationCallBack      callBack;

@end

@implementation GDLocationManager

+ (instancetype)manager
{
    static GDLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[[self class] alloc] init];
        /********** 定位服务 **********/
        
        manager.locationManager = [[CLLocationManager alloc]init];
        [manager.locationManager requestAlwaysAuthorization];
        manager.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.locationManager.distanceFilter = 10;
        
        /********** －－－－ **********/
    });
    return manager;
}

- (void)startUpdatingLocation:(LocationCallBack)callBack
{
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.callBack = callBack;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [manager requestWhenInUseAuthorization];
            }
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    [GDLocationManager manager].longitude = currLocation.coordinate.longitude;
    [GDLocationManager manager].latitude = currLocation.coordinate.latitude;
    [GDLocationManager manager].altitude = currLocation.altitude;
    
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                             objectForKey:@"AppleLanguages"];
    
    
    // 强制 成 简体中文
    [[NSUserDefaults
      standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",
                                       nil] forKey:@"AppleLanguages"];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *city = placemark.locality;
            if (!city) {
                city = placemark.administrativeArea;
            }
            [GDLocationManager manager].city = city;
            [GDLocationManager manager].province = placemark.administrativeArea;
            [GDLocationManager manager].district = placemark.subLocality;
            if (self.callBack) {
                self.callBack(YES,[GDLocationManager manager]);
            }
        }
        else if (error == nil && [array count] == 0)
        {
            if (self.callBack) {
                self.callBack(NO,[GDLocationManager manager]);
            }
        }
        else if (error != nil)
        {
            if (self.callBack) {
                self.callBack(NO,[GDLocationManager manager]);
            }
        }
    }];
    [manager stopUpdatingLocation];
    // 还原Device 的语言
    [[NSUserDefaults
      standardUserDefaults] setObject:userDefaultLanguages
     forKey:@"AppleLanguages"];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        if (self.callBack) {
            self.callBack(NO,[GDLocationManager manager]);
        }
    }
    if ([error code] == kCLErrorLocationUnknown)
    {
        if (self.callBack) {
            self.callBack(NO,[GDLocationManager manager]);
        }
    }
}


@end
