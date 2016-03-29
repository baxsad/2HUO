//
//  MFUHomeImageCollectionCell.m
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFUHomeImageCollectionCell.h"
#import <YYWebImage/YYWebImage.h>

@interface MFUHomeImageCollectionCell ()

@end

@implementation MFUHomeImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setProductIamge:(NSString *)url size:(CGSize)size
{
    self.image.url = url;
    @weakify(self);
    [self.image.layer yy_setImageWithURL:[NSURL URLWithString:url]
                         placeholder:nil
                             options:YYWebImageOptionAvoidSetImage
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                              @strongify(self);
                              if (!self.image) return;
                              if (image && stage == YYWebImageStageFinished) {
                                  int width = image.size.width;
                                  int height = image.size.height;
                                  CGFloat scale = (height / width) / (size.height / size.width);
                                  if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                      self.image.contentMode = UIViewContentModeScaleAspectFill;
                                      self.image.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                  } else { // 高图只保留顶部
                                      self.image.contentMode = UIViewContentModeScaleToFill;
                                      self.image.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                  }
                                  self.image.image = image;
                                  if (from != YYWebImageFromMemoryCacheFast) {
                                      CATransition *transition = [CATransition animation];
                                      transition.duration = 0.15;
                                      transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                      transition.type = kCATransitionFade;
                                      [self.image.layer addAnimation:transition forKey:@"contents"];
                                  }
                              }
                          }];
}

@end
