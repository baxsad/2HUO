//
//  MFJStatusButton.h
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MFJStatusButtonType) {
    MFJStatusButtonTypeNormal,
    MFJStatusButtonTypeLike,
};

@interface MFJStatusParams : NSObject

@property (nonatomic, copy  ) NSString    * defaultTitle;

@property (nonatomic, copy  ) NSString    * normalImage;

@property (nonatomic, copy  ) NSString    * selectImage;

@property (nonatomic, copy  ) NSString    * title;

@property (nonatomic, strong) UIFont      * titleFont;

@property (nonatomic, strong) UIColor     * titleColor;

@property (nonatomic, strong) UIColor     * titleSelectColor;

@property (nonatomic, strong) UIColor     * backGroundColor;

@property (nonatomic, assign) CGRect        buttonFrame;

@property (nonatomic, assign) CGSize        imageSize;

@end

@interface MFJStatusButton : UIButton

@property (nonatomic, assign) BOOL                 animated;

@property (nonatomic, strong) MFJStatusParams    * model;

@property (nonatomic, copy  ) void (^ButtonClick)();

- (instancetype)initWithFrame:(CGRect)rect
                        image:(NSString *)image
                  selectImage:(NSString *)selectIamge
                         text:(NSString *)text
                         type:(MFJStatusButtonType)type;

- (void)configureStatus:(BOOL)selected
                   text:(NSString *)text
               animated:(BOOL)animated;

@end
