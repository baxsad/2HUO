//
//  MFJGroupReq.m
//  2HUO
//
//  Created by iURCoder on 4/2/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJGroupReq.h"
#import "MFJReq.h"
#import "MFJReqAction.h"

@interface MFJGroupReq ()

@property (nonatomic, strong, readwrite) NSMutableSet *requestsSet;

@end

@implementation MFJGroupReq

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestsSet = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Add Requests
- (void)addRequest:(MFJReq *)req {
    NSParameterAssert(req);
    NSAssert([req isKindOfClass:[MFJReq class]],
             @"Rqe should be kind of MFJRqe");
    if ([self.requestsSet containsObject:req]) {
#ifdef DEBUG
        NSLog(@"Add SAME Req into Group set");
#endif
    }
    
    [self.requestsSet addObject:req];
}

- (void)addRequests:(NSSet *)reqs {
    NSParameterAssert(reqs);
    NSAssert([reqs count] > 0, @"Reqs amounts should greater than ZERO");
    [reqs enumerateObjectsUsingBlock:^(id  obj, BOOL * stop) {
        if ([obj isKindOfClass:[MFJReq class]]) {
            [self.requestsSet addObject:obj];
        } else {
            __unused NSString *hintStr = [NSString stringWithFormat:@"%@ %@",
                                          [[obj class] description],
                                          @"Req should be kind of MFJReq"];
            NSAssert(NO, hintStr);
            return ;
        }
    }];
}

- (void)start {
    NSAssert([self.requestsSet count] != 0, @"Group API Amount can't be 0");
    [[MFJReqAction shareInstance] sendRequests:self];
}


@end
