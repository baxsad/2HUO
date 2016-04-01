//
//  MFJPhotoGroupView.h
//  2HUO
//
//  Created by iURCoder on 3/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MFJLoopViewPageControlPosition)
{
    MFJLoopViewPageControlPositionCenter,
    MFJLoopViewPageControlPositionRight,
    MFJLoopViewPageControlPositionLeft
};

typedef NS_ENUM(NSInteger, MFJLoopImageType)
{
    MFJLoopImageTypeLocal,
    MFJLoopImageTypeRemote
};

typedef void(^DidSelectMFJLoopItemBlock)(NSInteger);


@interface MFJLoopView : UIView

@property (nonatomic, assign) MFJLoopViewPageControlPosition pageControlPosition;
@property (nonatomic, assign) CGFloat scrollDuration;//默认 2.0f
@property (nonatomic, assign) UIViewContentMode MFJLoopImageViewContentMode;
@property (nonatomic, strong) UIColor *titleLabelTextColor; //默认黑色
@property (nonatomic, strong) UIFont  *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, strong) UIColor *pageControlCurrentPageColor;
@property (nonatomic, strong) UIColor *pageControlNormalPageColor;
@property (nonatomic, assign) BOOL turnOffInfiniteLoop;//默认 no
@property (nonatomic, assign) BOOL pageControlHiden;

+ (instancetype)loopViewWithFrame:(CGRect)frame
                     placeholderImage:(UIImage *)placeholderImage
                               images:(NSArray *)images
                               titles:(NSArray *)titles
                        selectedBlock:(DidSelectMFJLoopItemBlock)selectedBlock;
- (void)loadImages:(NSArray *)images;
- (void)loadImages:(NSArray *)images titles:(NSArray *)titles;
@end
