//
//  MFJBaseSettingViewController.m
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJBaseSettingViewController.h"
#import "MFJSettingCell.h"

@interface MFJBaseSettingViewController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MFJBaseSettingViewController

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MFJSettingCell class]) bundle:nil] forCellReuseIdentifier:@"MFJSettingCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = UIColorHex(0xebebeb);
    self.view = tableView;
}

- (void)reloadData
{
    [((UITableView *)self.view) reloadData];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xebebeb);
    _allGroups = [NSMutableArray array];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MFJSettingGroup *group = _allGroups[section];
    return group.items.count;
}

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建一个ZFSettingCell
    MFJSettingCell *cell = [MFJSettingCell settingCellWithTableView:tableView];
    
    // 2.取出这行对应的模型（ZFSettingItem）
    MFJSettingGroup *group = _allGroups[indexPath.section];
    cell.item = group.items[indexPath.row];
    __block MFJSettingCell *weakCell = cell;
    cell.switchChangeBlock = ^ (BOOL on){
        if (weakCell.item.switchBlock) {
            weakCell.item.switchBlock(on);
        }
    };
    return cell;
}

#pragma mark 点击了cell后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0.取出这行对应的模型
    MFJSettingGroup *group = _allGroups[indexPath.section];
    MFJSettingItem *item = group.items[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 1.取出这行对应模型中的block代码
    if (item.selected) {
        // 执行block
        item.selected();
    }
}

#pragma mark 返回每一组的header标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MFJSettingGroup *group = _allGroups[section];
    
    if (group.header) {
        return group.header;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MFJSettingGroup *group = _allGroups[section];
    if (group.headerView) {
        return group.headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MFJSettingGroup *group = _allGroups[section];
    if (group.headerView) {
        return group.headerView.frame.size.height;
    }else{
        if (group.header) {
            return [group.header heightForFont:[UIFont systemFontOfSize:17] width:Screen_Width]+10;
        }else
        {
            return 0.00000001;
        }
    }
}

#pragma mark 返回每一组的footer标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    MFJSettingGroup *group = _allGroups[section];
    
    if (group.footer) {
        return group.footer;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MFJSettingGroup *group = _allGroups[section];
    if (group.footerView) {
        return group.footerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    MFJSettingGroup *group = _allGroups[section];
    if (group.footerView) {
        return group.footerView.frame.size.height;
    }else{
        if (group.footer) {
            return [group.footer heightForFont:[UIFont systemFontOfSize:17] width:Screen_Width]+10;
        }else
        {
            return 0.00000001;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFJSettingGroup *group = _allGroups[indexPath.section];
    MFJSettingItem *item = group.items[indexPath.row];
    if (item.itemHeight>0) {
        return item.itemHeight;
    }
    return 45;
}


@end
