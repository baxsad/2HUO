//
//  MFJRequestManager.h
//  2HUO
//
//  Created by iURCoder on 4/1/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFJBaseRequest;

@interface MFJRequestManager : NSObject

- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (nullable instancetype)sharedMFJREQManager;

- (void)sendRequest:(nonnull MFJBaseRequest  *)req;

- (void)cancelRequest:(nonnull MFJBaseRequest  *)req;

@end
