//
//  GDImageButton.m
//  2HUO
//
//  Created by iURCoder on 5/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDImageButton.h"

@interface GDImageButton ()<UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, assign) CGSize    ButtonSize;

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImageView * image;

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIViewController       *currentVc;

@property (nonatomic, assign) CGPoint buttonCenter;

@property (nonatomic, copy) TapBlock block;

@end

@implementation GDImageButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image
{
    if (self = [super initWithFrame:frame]) {
        
        _ButtonSize = frame.size;
        _FontSize = 15;
        _imageSize = CGSizeMake(15, 15);
        _margin = 5;
        
        _title = [[UILabel alloc] init];
        _title.text = title;
        _titleName = title;
        _title.tintColor = [UIColor blackColor];
        _title.font = [UIFont boldSystemFontOfSize:_FontSize];
        [self addSubview:_title];
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageSize.width, _imageSize.height)];
        _image.image = [UIImage imageNamed:image];
        _imageName = image;
        [self addSubview:_image];
        
        [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self layout];
        
    }
    return self;
}

- (void)showInController:(UIViewController *)vc
{
    self.currentVc = vc;
    self.nav = vc.navigationController;
    self.nav.delegate = self;
    [self.nav.navigationBar addSubview:self];
    self.buttonCenter = CGPointMake(self.nav.navigationBar.frame.size.width/2.0, self.nav.navigationBar.frame.size.height/2.0);
    [self layout];
}

- (void)layout
{
    CGFloat titleWidth = [_titleName widthForFont:[UIFont boldSystemFontOfSize:(CGFloat)_FontSize]];
    CGFloat imageWidth = _imageSize.width;
    
    self.frame = CGRectMake(0, 0, titleWidth+imageWidth+_margin, _ButtonSize.height);
    self.center = self.buttonCenter;
    self.title.frame = CGRectMake(0, 0, titleWidth, _ButtonSize.height);
    
    CGFloat imageY = _ButtonSize.height/2.0 - _imageSize.height/2.0;
    self.image.frame = CGRectMake(titleWidth+_margin, imageY, _imageSize.width, _imageSize.height);
}

- (void)reloadTitle:(NSString *)title
{
    _titleName = title;
    self.title.text = _titleName;
    [self layout];
}

- (void)setFontSize:(CGFloat)FontSize
{
    _FontSize = FontSize;
    self.title.font = [UIFont boldSystemFontOfSize:_FontSize];
    [self layout];
}

- (void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    [self layout];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _title.textColor = _titleColor;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([viewController isEqual:self.currentVc])
    {
        [self showAnimation];
    }
    else
    {
        [self hideAnimatrion];
    }
}

- (void)showAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hideAnimatrion
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
}

- (void)tapAction
{
    if (self.block) {
        self.block();
    }
}

- (void)buttonWhenTap:(TapBlock)block
{
    self.block = block;
}

@end
