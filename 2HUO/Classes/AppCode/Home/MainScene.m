//
//  MainScene.m
//  2HUO
//
//  Created by iURCoder on 4/29/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MainScene.h"
#import "EHHomeScene.h"
#import "EHMineScene.h"

@implementation MainScene


- (void)viewDidLoad
{
    [super viewDidLoad];
    EHMineScene * mineScene = [[EHMineScene alloc] init];
    EHHomeScene * homeScene = [[EHHomeScene alloc] init];
    self.viewControllers = @[mineScene,homeScene];
}

@end
