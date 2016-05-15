//
//  GDImageButton.h
//  2HUO
//
//  Created by iURCoder on 5/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)();

@interface GDImageButton : UIButton

@property (nonatomic, strong) UIColor  *titleColor;
@property (nonatomic, assign) CGFloat   FontSize;
@property (nonatomic, assign) CGSize    imageSize;
@property (nonatomic, assign) CGFloat   margin;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image;

- (void)reloadTitle:(NSString *)title;

- (void)showInController:(UIViewController *)vc;

- (void)buttonWhenTap:(TapBlock)block;

@end
