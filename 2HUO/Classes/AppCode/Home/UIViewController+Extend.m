//
//  UIViewController+Extend.m
//  2HUO
//
//  Created by iURCoder on 5/6/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "UIViewController+Extend.h"
#import "EHSignScene.h"
#import "IHNavigationController.h"

#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsManager.h"

@implementation UIViewController (Extend)

- (void)showSignScene{
    [self showSignSceneWithSignStatus:nil];
}

- (void)showSignSceneWithSignStatus:(void(^)(BOOL status))status{
    
    [[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:[[RZZoomAlphaAnimationController alloc] init]];
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    
    EHSignScene* signScene = [[EHSignScene alloc] init];
    signScene.signStatus = status;
    
    IHNavigationController * nav = [[IHNavigationController alloc] initWithRootViewController:signScene];
    
    [nav setTransitioningDelegate:[RZTransitionsManager shared]];
    [self presentViewController:nav animated:YES completion:nil];
    
}



@end
