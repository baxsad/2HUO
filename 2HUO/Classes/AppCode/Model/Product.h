//
//  Product.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "User.h"
#import "Tag.h"

@protocol ProductInfo,Tag;

@interface Product : JSONModel

@property (nonatomic, copy) NSArray <ProductInfo> * list;

@end


@interface ProductInfo : JSONModel

@property (nonatomic, assign) NSInteger       pid;
@property (nonatomic, strong) User          * user;
@property (nonatomic, copy  ) NSArray <Tag> * tags;
@property (nonatomic, assign) NSInteger       likeCount;
@property (nonatomic, assign) BOOL            isLike;
@property (nonatomic, assign) NSInteger       createTime;
@property (nonatomic, assign) NSInteger       updateTime;
@property (nonatomic, assign) NSInteger       presentPrice;
@property (nonatomic, assign) NSInteger       originalPrice;
@property (nonatomic, copy  ) NSString      * school;
@property (nonatomic, copy  ) NSString      * content;
@property (nonatomic, copy  ) NSString      * transactionMode;
@property (nonatomic, copy  ) NSString      * type;
@property (nonatomic, copy  ) NSString      * title;
@property (nonatomic, copy  ) NSString      * location;
@property (nonatomic, copy  ) NSArray       * images;

@property (nonatomic, copy  ) NSString      * objectId;


@end