//
//  MFJRequestManager.h
//  2HUO
//
//  Created by iURCoder on 4/1/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFJReq,MFJGroupReq;

typedef void(^listenCallBack)(MFJReq * _Nonnull req);

@interface MFJReqAction : NSObject

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (nonnull instancetype)shareInstance;

+ (nonnull instancetype)action;

- (void)Send:(nonnull MFJReq  *)req;

- (void)sendRequests:(nonnull MFJGroupReq *)groupreq;

- (void)cancelRequest:(nonnull MFJReq  *)req;

- (void)listen:(nonnull listenCallBack)block;

@end
