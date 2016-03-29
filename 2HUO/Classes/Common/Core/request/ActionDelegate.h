//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseRequest;

@protocol ActionDelegate <NSObject>
/** 请求状态 */
-(void)handleActionMsg:(BaseRequest *)req;
@optional
/** 下载进度 */
-(void)handleProgressMsg:(BaseRequest *)req;
@end