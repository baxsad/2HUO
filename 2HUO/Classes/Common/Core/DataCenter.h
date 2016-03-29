//
//  DataCenter.h
//  BiHu_iPhone
//
//  Created by iURCoder on 1/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseRequest;
@interface DataCenter : NSObject
AS_SINGLETON(DataCenter)
@property (nonatomic, strong) BaseRequest *uploadPictureRequest;
@property (nonatomic, strong) Action *action;

- (void)uploadPictureWithImage:(UIImage*)image with:(UploadPictureModel)model callBack:(void(^)(BOOL state,NSString *fileName))callBack;

@end
