//
//  EHTelLoginScene.h
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "IHBaseViewController.h"

typedef void(^LoginSuccessCallBack)();

@interface EHTelLoginScene : IHBaseViewController

@property (nonatomic, copy) LoginSuccessCallBack LoginSuccessBlock;

@end
