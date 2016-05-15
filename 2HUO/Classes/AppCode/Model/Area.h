//
//  Area.h
//  2HUO
//
//  Created by iURCoder on 5/11/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol City,Area;

@interface Areas : JSONModel

@property (nonatomic, strong) NSArray <Area> * data;

@end

@interface Area : JSONModel

@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, copy  ) NSString *provinceNameCH;
@property (nonatomic, copy  ) NSString *provinceNameEN;
@property (nonatomic, strong) NSArray <City> * city;

@end

@interface City : JSONModel

@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, copy  ) NSString *cityNameCH;
@property (nonatomic, copy  ) NSString *cityNameEN;
@property (nonatomic, assign) NSInteger provinceId;

@end