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
#import "School.h"
#import "SellerModel.h"

@protocol PostInfo,Tag;

@interface Post : JSONModel

@property (nonatomic, copy) NSArray <PostInfo> * data;

@end


@interface PostInfo : JSONModel

@property (nonatomic, assign) NSInteger       pid;
@property (nonatomic, strong) User          * user;
@property (nonatomic, copy  ) NSArray <Tag> * tags;
@property (nonatomic, assign) NSInteger       likeCount;
@property (nonatomic, assign) BOOL            isLike;
@property (nonatomic, assign) NSInteger       createTime;
@property (nonatomic, assign) NSInteger       updateTime;
@property (nonatomic, assign) float           presentPrice;
@property (nonatomic, assign) float           originalPrice;
@property (nonatomic, assign) float           shippingCount;
@property (nonatomic, strong) School        * school;
@property (nonatomic, copy  ) NSString      * content;
@property (nonatomic, copy  ) NSString      * transactionMode;
@property (nonatomic, copy  ) NSString      * type;
@property (nonatomic, copy  ) NSString      * title;
@property (nonatomic, copy  ) NSArray       * images;
@property (nonatomic, strong) SellerModel   * address;

@end