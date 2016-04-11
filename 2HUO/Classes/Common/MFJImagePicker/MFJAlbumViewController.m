//
//  MFJAlbumViewController.m
//  2HUO
//
//  Created by iURCoder on 4/9/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJAlbumViewController.h"
#import "MFJPickerViewController.h"
#import "AssetManager.h"
#import "MFJAssetModel.h"
#import "MFJAlbumCell.h"
#import "MFJPhotoPickerViewController.h"

@interface MFJAlbumViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_albumArr;
}

@end

@implementation MFJAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configTableView];
}

- (void)configTableView {
    MFJPickerViewController *imagePickerVc = (MFJPickerViewController *)self.navigationController;
    [[AssetManager manager] getAllAlbums:imagePickerVc.allowPickingVideo completion:^(NSArray<MFJAssetModel *> *models) {
        _albumArr = [NSMutableArray arrayWithArray:models];
        
        CGFloat top = 4;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height - top) style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MFJAlbumCell" bundle:nil] forCellReuseIdentifier:@"MFJAlbumCell"];
        [self.view addSubview:_tableView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFJAlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MFJAlbumCell"];
    cell.model = _albumArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFJPhotoPickerViewController *photoPickerVc = [[MFJPhotoPickerViewController alloc] init];
    photoPickerVc.model = _albumArr[indexPath.row];
    [self.navigationController pushViewController:photoPickerVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
