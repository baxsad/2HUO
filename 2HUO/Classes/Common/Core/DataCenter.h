//
//  DataCenter.h
//  2HUO
//
//  Created by iURCoder on 5/4/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

+ (instancetype)defaultCenter;

- (void)uploadPicture:(UIImage *)image progress:(void (^)(float progress))progress response:(void (^)(NSString *image))response;

@end
