//
//  School.h
//  2HUO
//
//  Created by iURCoder on 5/3/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol School;

@interface SchooData : JSONModel

@property (nonatomic, strong) NSArray<School> * data;

@end

@interface School : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic,   copy) NSString  *name;
@property (nonatomic,   copy) NSString  *type;
@property (nonatomic,   copy) NSString  *nature;
@property (nonatomic,   copy) NSString  *campus;
@property (nonatomic,   copy) NSString  *location;
@property (nonatomic,   copy) NSString  *province;

@end


