//
//  Comments.h
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "User.h"

@protocol Comment;

@interface Comments : JSONModel

@property (nonatomic, strong) NSArray<Comment>*data;

@end


@interface Comment : JSONModel

@property (nonatomic, assign) NSInteger pcid;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger atUserId;
@property (nonatomic, copy  ) NSString *atUser;
@property (nonatomic, copy  ) NSString *createdTime;
@property (nonatomic, assign) float     biddingPrice;
@property (nonatomic, strong) User     *user;
@property (nonatomic, copy  ) NSString *content;

@end