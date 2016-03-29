//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "Action.h"
#import "RACEXTScope.h"
#import "ReactiveCocoa.h"
#import "MYREQUEST.h"
@interface SceneModel : NSObject<ActionDelegate>
@property(nonatomic,strong)Action *action;
+ (instancetype)SceneModel;
- (void)handleActionMsg:(BaseRequest *)msg;
/**
 * 发送下载请求
 */
- (void)DO_DOWNLOAD:(BaseRequest *)req;
/**
 * 发送普通请求
 */
- (void)SEND_ACTION:(BaseRequest *)req;
/**
 * 发送普通请求，并缓存
 */
- (void)SEND_CACHE_ACTION:(BaseRequest *)req;
/**
 * 发送请求，不缓存
 */
- (void)SEND_NO_CACHE_ACTION:(BaseRequest *)req;
/**
 * 第一次请求从缓存那数据，第二次不从缓存拿数据请求最新的
 */
- (void)SEND_IQ_ACTION:(BaseRequest *)req;
/**
 * 创建请求对象请求
 */
- (void)loadSceneModel;
@end