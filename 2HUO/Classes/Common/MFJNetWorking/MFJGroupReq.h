//
//  MFJGroupReq.h
//  2HUO
//
//  Created by iURCoder on 4/2/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFJReq;
@class MFJGroupReq;

@protocol MFJGroupRequestsProtocol <NSObject>

- (void)groupRequestsDidFinished:(nonnull MFJGroupReq *)groupReq;

@end

@interface MFJGroupReq : NSObject

@property (nonatomic, strong, readonly, nullable) NSMutableSet *requestsSet;

@property (nonatomic, weak, nullable) id<MFJGroupRequestsProtocol> delegate;

- (void)addRequest:(nonnull MFJReq *)req;

- (void)addRequests:(nonnull NSSet *)reqs;

- (void)start;

@end
