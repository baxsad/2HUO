//
//  EHSettingUserInfoScene.m
//  2HUO
//
//  Created by iURCoder on 5/13/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHSettingUserInfoScene.h"
#import <YYWebImage/YYWebImage.h>
#import "GDImagePickerController.h"
#import "MFJActionSheet.h"

typedef void(^UploadSexBlock)(NSString *sex);

@interface EHSettingUserInfoScene ()

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UILabel * headerTitle;
@property (nonatomic, strong) UIImageView * headerImage;
@property (nonatomic, strong) GDImagePickerController   * imagePicker;
@property (nonatomic, strong) MFJActionSheet       * sheet;
@property (nonatomic,   copy) UploadSexBlock         uploadSexBlock;

@end

@implementation EHSettingUserInfoScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = BGCOLOR;
    
    @weakify(self);
    MFJSettingGroup * group = [[MFJSettingGroup alloc] init];
    
    MFJSettingItem * item2 = [[MFJSettingItem alloc] init];
    item2.title = @"昵称";
    item2.type = MFJSettingItemTypeArrowSubTitle;
    item2.itemHeight = 60;
    item2.subTitle = USER.nick;
    item2.selected = ^{
        [[GDRouter sharedInstance] open:@"GD://updateUserNick"];
    };
    
    MFJSettingItem * item3 = [[MFJSettingItem alloc] init];
    item3.title = @"简介";
    item3.type = MFJSettingItemTypeArrowSubTitle;
    item3.itemHeight = 60;
    item3.subTitle = USER.desc.isNotEmpty ? USER.desc : @"这人好懒呀！";
    item3.selected = ^{
        [[GDRouter sharedInstance] open:@"GD://updateUserDesc"];
    };
    
    
    MFJSettingItem * item1 = [[MFJSettingItem alloc] init];
    item1.title = @"学校";
    item1.type = MFJSettingItemTypeArrowSubTitle;
    item1.itemHeight = 60;
    item1.subTitle = USER.school.name.isNotEmpty ? (USER.school.campus.isNotEmpty ? [NSString stringWithFormat:@"%@ %@",USER.school.name,USER.school.campus] : USER.school.name) : @"还未设置学校";
    @weakify(item1);
    item1.selected = ^{
        [[GDRouter sharedInstance] open:@"GD://school"];
        [GDRouter sharedInstance].receiveCallBack = ^(School * model){
            [[AccountCenter shareInstance] updateUserInfo:@{@"sid":@(model.id)} complete:^(BOOL success) {
                if (success) {
                    @strongify(self,item1);
                    FuckYou(@"更新用户学校成功");
                    item1.subTitle = USER.school.campus.isNotEmpty ? [NSString stringWithFormat:@"%@ %@",USER.school.name,USER.school.campus] : USER.school.name;
                    [self reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
                }
            }];
        };
    };
    
    MFJSettingItem * item4 = [[MFJSettingItem alloc] init];
    item4.title = @"年龄";
    item4.type = MFJSettingItemTypeArrowSubTitle;
    item4.itemHeight = 60;
    item4.subTitle = USER.age.isNotEmpty ? USER.age : @"未知";
    
    MFJSettingItem * item5 = [[MFJSettingItem alloc] init];
    item5.title = @"性别";
    item5.type = MFJSettingItemTypeArrowSubTitle;
    item5.itemHeight = 60;
    item5.subTitle = USER.sex.isNotEmpty ? USER.sex : @"未知";
    item5.selected = ^{
        [self.sheet showInView:[UIApplication sharedApplication].keyWindow animated:YES];
    };
    
    group.items = @[item2,item3,item1,item4,item5];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
    _headerView.backgroundColor = BGCOLOR;
    group.headerView = _headerView;
    
    self.headerTitle = [[UILabel alloc] init];
    self.headerTitle.text = @"头像";
    self.headerTitle.font = [UIFont systemFontOfSize:15];
    self.headerTitle.textColor = UIColorHex(0x515151);
    [self.headerView addSubview:self.headerTitle];
    CGFloat titleWidth = [@"头像" widthForFont:[UIFont systemFontOfSize:15]];
    self.headerTitle.frame = CGRectMake(15, 50-8, titleWidth, 16);
    
    self.headerImage = [[UIImageView alloc] init];
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:USER.avatar] options:YYWebImageOptionProgressiveBlur];
    self.headerImage.clipsToBounds = YES;
    self.headerImage.layer.cornerRadius = 30;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.frame = CGRectMake(Screen_Width-93, 20, 60, 60);
    [self.headerView addSubview:self.headerImage];
    
    UIImageView * arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:[@"MFJSetting.bundle" stringByAppendingPathComponent:@"arrow"]]];
    [self.headerView addSubview:arrow];
    arrow.frame = CGRectMake(Screen_Width-23, 50-7, 8, 14);
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(15, 100-1/ScreenScale, Screen_Width-15, 1/ScreenScale)];
    bottomLine.backgroundColor = UIColorHex(0xebebeb);
    [self.headerView addSubview:bottomLine];
    
    self.headerView.userInteractionEnabled = YES;
    [self.headerView whenTapped:^{
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    self.allGroups = @[group].mutableCopy;
    
    @weakify(item2);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UpdateUserNick" object:nil] subscribeNext:^(id x) {
        NSNotification * noti = x;
        [[AccountCenter shareInstance] updateUserInfo:@{@"nick":noti.object} complete:^(BOOL success) {
            @strongify(self,item2);
            if (success) {
                FuckYou(@"更新用户昵称成功");
                item2.subTitle = USER.nick;
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
            }
        }];
    }];
    
    @weakify(item3);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UpdateUserDesc" object:nil] subscribeNext:^(id x) {
        NSNotification * noti = x;
        [[AccountCenter shareInstance] updateUserInfo:@{@"des":noti.object} complete:^(BOOL success) {
            @strongify(self,item3);
            if (success) {
                FuckYou(@"更新用户简介成功");
                item3.subTitle = USER.desc;
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
            }
        }];
    }];
    
    @weakify(item5);
    self.uploadSexBlock = ^(NSString *sex){
        [[AccountCenter shareInstance] updateUserInfo:@{@"sex":sex} complete:^(BOOL success) {
            @strongify(self,item5);
            if (success) {
                FuckYou(@"更新性别成功");
                item5.subTitle = USER.sex;
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
            }
        }];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GDImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[GDImagePickerController alloc] initWithMaxImagesCount:1];
        @weakify(self);
        _imagePicker.complete = ^(NSArray * imageArray){
            for (NSData * selectImageData in imageArray) {
                @strongify(self);
                [[DataCenter defaultCenter] uploadPicture:[UIImage imageWithData:selectImageData] progress:^(float progress) {
                    
                } response:^(NSString *image) {
                    
                    [[AccountCenter shareInstance] updateUserInfo:@{@"avatar":image} complete:^(BOOL success) {
                        if (success) {
                            // 上传成功
                            FuckYou(@"更新用户头像成功！");
                            [self.headerImage yy_setImageWithURL:[NSURL URLWithString:USER.avatar] options:YYWebImageOptionProgressiveBlur];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
                        }
                    }];
                }];
            }
            
        };
    }
    return _imagePicker;
}

- (MFJActionSheet *)sheet
{
    if (!_sheet) {
        
        MFJActionSheetSection * s1 = [MFJActionSheetSection sectionWithTitle:@"提示" message:@"选择你的性别信息！" buttonTitles:@[@"男",@"女"] buttonStyle:MFJActionSheetButtonStyleInstagram];
        
        MFJActionSheetSection * s2 = [MFJActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:MFJActionSheetButtonStyleYellow];
        
        _sheet = [[MFJActionSheet alloc] initWithSections:@[s1,s2]];
        
        @weakify(self);
        _sheet.buttonClickBlock = ^(MFJActionSheet * sheet , NSIndexPath * indexPath){
            NSString * sex;
            if (indexPath.row == 0) {
                sex = @"男";
            }
            if (indexPath.row == 1) {
                sex = @"女";
            }
            if (sex.isNotEmpty) {
                @strongify(self);
                if (self.uploadSexBlock) {
                    self.uploadSexBlock(sex);
                }
            }
        };
        
    }
    return _sheet;
}

@end
