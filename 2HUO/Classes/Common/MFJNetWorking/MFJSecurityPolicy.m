//
//  MFJSecurityPolicy.m
//  2HUO
//
//  Created by iURCoder on 4/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJSecurityPolicy.h"

@interface MFJSecurityPolicy ()

@property (readwrite, nonatomic, assign) MFJSSLPinningMode SSLPinningMode;

@end

@implementation MFJSecurityPolicy

+ (instancetype)policyWithPinningMode:(MFJSSLPinningMode)pinningMode {
    MFJSecurityPolicy *securityPolicy = [[MFJSecurityPolicy alloc] init];
    if (securityPolicy) {
        securityPolicy.SSLPinningMode           = pinningMode;
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName      = YES;
    }
    return securityPolicy;
}

@end
