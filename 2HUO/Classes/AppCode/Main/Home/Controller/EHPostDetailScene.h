//
//  EHPostDetailScene.h
//  2HUO
//
//  Created by iURCoder on 5/10/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "IHBaseViewController.h"

@class PostInfo;

@interface EHPostDetailScene : IHBaseViewController

@property (nonatomic, copy  ) NSString * pid;
@property (nonatomic, strong) PostInfo * post;

@end
