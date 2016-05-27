//
//  EHProfileScene.m
//  2HUO
//
//  Created by iURCoder on 5/23/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "EHProfileScene.h"
#import "User.h"
#import "EHPostUserCell.h"
#import "EHProfilePostCell.h"
#import "Post.h"

@interface EHProfileScene ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) GDReq * getProfileRequest;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation EHProfileScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BGCOLOR;
    self.view.backgroundColor = BGCOLOR;
    self.title = self.user.nick;
    self.dataArray = @[].mutableCopy;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"EHPostUserCell" bundle:nil] forCellReuseIdentifier:@"EHPostUserCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHProfilePostCell" bundle:nil] forCellReuseIdentifier:@"EHProfilePostCell"];
    
    self.getProfileRequest = [GDRequest getProfileRequest];
    [self.getProfileRequest.params setValue:self.user.uid forKey:@"uid"];
    [self.getProfileRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            Post * model = [[Post alloc] initWithDictionary:req.output error:nil];
            
        }
        if (req.failed) {
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 220;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EHPostUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EHPostUserCell"];
        [cell configModel:self.user];
        return cell;
    }else{
        return nil;
    }
}

@end
