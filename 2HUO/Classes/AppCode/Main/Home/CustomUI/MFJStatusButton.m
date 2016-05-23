//
//  MFJStatusButton.m
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJStatusButton.h"

#define IMGSize CGSizeMake(15, 15)

#define TITLEFont [UIFont systemFontOfSize:12]

#define BackGroundColor [UIColor clearColor]

#define TITLEColor UIColorHex(0x797979)

#define TITLESelectedColor UIColorHex(0xD82820)

@implementation MFJStatusParams

@end


@interface MFJStatusFrameModel : NSObject

- (instancetype)initWithStatusModel:(MFJStatusParams *)params;

@property (nonatomic, strong) MFJStatusParams  *  params;

@property (nonatomic, assign) CGRect              imageRect;

@property (nonatomic, assign) CGRect              titleRect;

@end


@implementation MFJStatusFrameModel

- (instancetype)initWithStatusModel:(MFJStatusParams *)params
{
    self = [super init];
    if (self) {
        
        self.params = params;
        CGSize lableSize;
        NSLineBreakMode lineBreakMode = NSLineBreakByClipping;
        UIFont * font = params.titleFont;
        CGSize size = CGSizeMake(1000, 15);
        if (!font) font = [UIFont systemFontOfSize:12];
        if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableDictionary *attr = [NSMutableDictionary new];
            attr[NSFontAttributeName] = font;
            
            if (lineBreakMode != NSLineBreakByWordWrapping) {
                NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                paragraphStyle.lineBreakMode = lineBreakMode;
                attr[NSParagraphStyleAttributeName] = paragraphStyle;
            }
            CGRect rect = [params.title boundingRectWithSize:size
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:attr context:nil];
            lableSize = rect.size;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            lableSize = [params.title sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
        }
        CGFloat totalWidh;
        if (lableSize.width == 0) {
            totalWidh = params.imageSize.width;
        }else{
            totalWidh = params.imageSize.width + 5 +lableSize.width;
        }
        
        CGRect  mainFrame = params.buttonFrame;
        
        CGFloat imageX = (mainFrame.size.width - totalWidh)*0.5;
        CGFloat imageY = mainFrame.size.height*0.5 - params.imageSize.height*0.5;
        CGFloat imagew = params.imageSize.width;
        CGFloat imageH = params.imageSize.height;
        self.imageRect = CGRectMake(imageX, imageY, imagew, imageH);
        
        CGFloat lableX = imageX  + imagew + 5;
        CGFloat lableY = mainFrame.size.height*0.5 - lableSize.height*0.5;
        CGFloat lableW = lableSize.width;
        CGFloat lableH = lableSize.height;
        self.titleRect = CGRectMake(lableX, lableY, lableW, lableH);
        
    }
    return self;
}

@end


@interface MFJStatusButton ()

@property (nonatomic, strong) UIImageView        * buttonImage;

@property (nonatomic, strong) UILabel            * title;

@property (nonatomic, assign) BOOL                 status;

@property (nonatomic, assign) MFJStatusButtonType  type;

@end

@implementation MFJStatusButton

- (instancetype)initWithFrame:(CGRect)rect
                        image:(NSString *)image
                  selectImage:(NSString *)selectIamge
                         text:(NSString *)text
                         type:(MFJStatusButtonType)type
{
    self = [super initWithFrame:rect];
    
    if (self) {
        
        MFJStatusParams * model = [[MFJStatusParams alloc] init];
        model.defaultTitle = text;
        model.normalImage = image;
        model.selectImage = selectIamge;
        model.title = text;
        model.buttonFrame = rect;
        model.imageSize = IMGSize;
        model.titleFont = TITLEFont;
        model.titleColor = TITLEColor;
        model.backGroundColor =  BackGroundColor;
        model.titleSelectColor = TITLESelectedColor;
        self.model = model;
        
        self.type = type;
        self.status = NO;
        self.animated = NO;
        
        self.buttonImage = [[UIImageView alloc] init];
        self.title = [[UILabel alloc] init];
        
        [self addSubview:self.buttonImage];
        [self addSubview:self.title];
        [self configureStatus:NO text:text animated:NO];
        [self addTarget:self action:@selector(buttonUpSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)configureStatus:(BOOL)selected text:(NSString *)text animated:(BOOL)animated
{
    self.status = selected;
    self.animated = animated;
    
    if (self.type == MFJStatusButtonTypeLike) {
        NSScanner* scan = [NSScanner scannerWithString:text];
        int val;
        BOOL isNumber = [scan scanInt:&val] && [scan isAtEnd];
        
        if (isNumber && [text integerValue] == 0) {
            self.model.title = self.model.defaultTitle;
            self.status = NO;// 如果为0肯定为未选中状态！
        }else{
            self.model.title = text;
        }
    }else{
        self.model.title = text;
    }
    
    MFJStatusFrameModel * frameModel = [[MFJStatusFrameModel alloc] initWithStatusModel:self.model];
    
    self.frame = frameModel.params.buttonFrame;
    self.backgroundColor = frameModel.params.backGroundColor;
    self.title.text = frameModel.params.title;
    self.title.font = frameModel.params.titleFont;
    self.title.textColor = frameModel.params.titleColor;
    self.buttonImage.image = [UIImage imageNamed:frameModel.params.normalImage];
    
    if (self.type == MFJStatusButtonTypeLike) {
        if (self.status) {
            if (frameModel.params.selectImage && frameModel.params.selectImage.length > 0) {
                self.buttonImage.image = [UIImage imageNamed:frameModel.params.selectImage];
            }else{
                self.buttonImage.image = [UIImage imageNamed:frameModel.params.normalImage];
            }
            self.title.textColor = frameModel.params.titleSelectColor;
        }else{
            self.buttonImage.image = [UIImage imageNamed:frameModel.params.normalImage];
            self.title.textColor = frameModel.params.titleColor;
        }
    }
    
    self.title.frame = frameModel.titleRect;
    self.buttonImage.frame = frameModel.imageRect;
    
}


- (void)buttonUpSelect:(UIButton *)sender
{
    
    if (!ISLOGIN) {
        if (self.ButtonClick) {
            self.ButtonClick();
        }
        return ;
    }
    if (self.type == MFJStatusButtonTypeLike) {
        
        NSInteger count;
        count = [self.model.title isEqualToString:self.model.defaultTitle] ? 0 : [self.model.title integerValue];
        
        if (self.status) {
            
            count -- ;
            
        }else{
            
            count ++ ;
            
        }
        
        NSString * text = @"";
        
        if (count == 0) {
            text = self.model.defaultTitle;
        }else{
            text = [NSString stringWithFormat:@"%li",count];
        }
        
        self.status = !self.status;
        
        [self configureStatus:self.status text:text animated:self.animated];
        
        
    }
    
    
    if (self.animated) {
        self.buttonImage.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.125 animations:^{
            self.buttonImage.transform=CGAffineTransformMakeScale(0.3f, 0.3f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.buttonImage.transform=CGAffineTransformMakeScale(1.37f, 1.37f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.buttonImage.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView    setAnimationCurve: UIViewAnimationCurveLinear];
    [UIView    setAnimationDelegate:self];
    [UIView    setAnimationDuration:0.125];
    [self setBackgroundColor:UIColorHex(0xffffff)];
    [UIView commitAnimations];
    
    if (self.ButtonClick) {
        self.ButtonClick();
    }
}

@end
