//
//  EHMineHeadCell.m
//  2HUO
//
//  Created by iURCoder on 5/3/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHMineHeadCell.h"
#import <YYWebImage/YYWebImage.h>

@interface EHMineHeadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *nikeLable;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLable;
@property (weak, nonatomic) IBOutlet UIImageView *tableviewArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nikeBottomConstraint;
@end

@implementation EHMineHeadCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.faceImageView.layer.cornerRadius = self.faceImageView.width * 0.5;
    self.faceImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.faceImageView.clipsToBounds = YES;
    self.faceImageView.userInteractionEnabled = YES;
}

- (void)reloadData
{
    if (!ISLOGIN) {
        self.tableviewArrow.hidden = YES;
        self.faceImageView.image =[UIImage imageNamed:@"DefaultHeader"];
        self.nikeLable.text = @"登录或注册";
        self.nikeLable.textColor = UIColorHex(0x515151);
        self.nikeBottomConstraint.constant = -8.5;
    }else{
        self.tableviewArrow.hidden = NO;
        self.nikeLable.text = USER.nick;
        self.nikeLable.textColor = UIColorHex(0x515151);
        self.nikeBottomConstraint.constant = 4;//原来是4
        self.praiseCountLable.text = USER.school!=nil ? [NSString stringWithFormat:@"就读于 %@",USER.school.name] : @"还未注册学校信息";
        [self.faceImageView yy_setImageWithURL:[NSURL URLWithString:USER.avatar] options:YYWebImageOptionProgressiveBlur];
    }
    if (USER.avatar.length == 0 && ISLOGIN) {
        self.faceImageView.image = [UIImage imageNamed:@"DefaultHeader"];
    }
}



@end
