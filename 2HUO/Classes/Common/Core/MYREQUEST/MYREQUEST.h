//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "BaseRequest.h"

/**
 * 可以把你的接口都放在这个类里面统一管理
 */

@interface MYREQUEST : BaseRequest

+ (id)uploadPictureModel:(UploadPictureModel)model;

+ (id)getHomeContents;


@end
