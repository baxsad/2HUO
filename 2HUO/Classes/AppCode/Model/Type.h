//
//  Type.h
//  2HUO
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol  Type;

@interface ProductType : JSONModel

@property (nonatomic, copy) NSArray<Type> * list;

@end

@interface Type : JSONModel

@property (nonatomic, assign) NSInteger mid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * type;

@end
