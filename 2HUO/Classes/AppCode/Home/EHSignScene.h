//
//  EHSignScene.h
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "IHBaseViewController.h"

@interface EHSignScene : IHBaseViewController

@property (nonatomic, copy) void (^signStatus)(BOOL success);
@property (nonatomic, copy) void (^dissMiss)(BOOL status);

@end
