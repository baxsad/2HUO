//
//  UIScrollView+HYSCat.h
//  BiHu_iPhone
//
//  Created by iURCoder on 12/2/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HYSCat)


- (void)scrollToTop;


- (void)scrollToBottom;


- (void)scrollToLeft;


- (void)scrollToRight;


- (void)scrollToTopAnimated:(BOOL)animated;


- (void)scrollToBottomAnimated:(BOOL)animated;


- (void)scrollToLeftAnimated:(BOOL)animated;


- (void)scrollToRightAnimated:(BOOL)animated;

@end
