//
//  MFJPickerViewController.m
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJPickerViewController.h"
#import "MFJAlbumViewController.h"
#import "MFJPhotoPickerViewController.h"
#import "AssetManager.h"
#import "MFJAssetModel.h"

@interface MFJPickerViewController ()

@end

@implementation MFJPickerViewController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount
{
    MFJPhotoPickerViewController *photoPickerVc = [[MFJPhotoPickerViewController alloc] init];
    self = [super initWithRootViewController:photoPickerVc];
    if (self) {
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9; // Default is 9 / 默认最大可选9张图片
        if (![[AssetManager manager] authorizationStatusAuthorized]) {
            
        } else {
//            [self pushToPhotoPickerVc];
        }
        [[AssetManager manager] getCameraRollAlbum:self.allowPickingVideo completion:^(MFJAlbumModel *model) {
            
            photoPickerVc.model = model;
            
            
        }];
    }
    return self;
}

- (void)pushToPhotoPickerVc
{
    
    MFJPhotoPickerViewController *photoPickerVc = [[MFJPhotoPickerViewController alloc] init];
    [[AssetManager manager] getCameraRollAlbum:self.allowPickingVideo completion:^(MFJAlbumModel *model) {
        
        photoPickerVc.model = model;
        [self pushViewController:photoPickerVc animated:YES];
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
