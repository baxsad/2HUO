//
//  Community.h
//  2HUO
//
//  Created by iURCoder on 4/29/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Community;

@interface Communitys : JSONModel

@property (nonatomic,   copy) NSArray <Community> * data;

@end

@interface Community : JSONModel

@property (nonatomic, assign) NSInteger  cid;
@property (nonatomic,   copy) NSString * c_name;
@property (nonatomic,   copy) NSString * c_icon;
@property (nonatomic,   copy) NSString * c_type;
@property (nonatomic,   copy) NSString * c_des;
@property (nonatomic, assign) NSInteger  count;

@end
