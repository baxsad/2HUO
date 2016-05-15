//
//  AeraAndSchool.h
//  2HUO
//
//  Created by iURCoder on 5/11/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "School.h"

@protocol AeraAndSchool,School;

@interface AeraAndSchools : JSONModel

@property (nonatomic, strong) NSArray <AeraAndSchool> * data;

@end

@interface AeraAndSchool : JSONModel

@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic,   copy) NSString *cityName;
@property (nonatomic, strong) NSArray <School> * school;

@end
