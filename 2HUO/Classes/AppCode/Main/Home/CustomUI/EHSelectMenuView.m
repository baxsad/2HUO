//
//  EHSelectMenuView.m
//  2HUO
//
//  Created by iURCoder on 5/4/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHSelectMenuView.h"

@interface EHSelectMenuView ()

@property (nonatomic, weak) IBOutlet UILabel * titleLable;
@property (nonatomic, weak) IBOutlet UILabel * contenLable;

@end

@implementation EHSelectMenuView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    @weakify(self);
    [self whenTapped:^{
        @strongify(self);
        if (self.block) {
            self.block();
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    self.titleLable.text = title;
}

- (void)setContent:(NSString *)content
{
    self.contenLable.text = content;
}

@end
