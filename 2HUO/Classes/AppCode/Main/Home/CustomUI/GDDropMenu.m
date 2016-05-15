//
//  GDDropMenu.m
//  2HUO
//
//  Created by iURCoder on 5/12/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDDropMenu.h"

@interface GDDropMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView      * fatherView;

@property (nonatomic, strong) UIView      * backGroundView;

@property (nonatomic, assign) CGSize        selefSize;

@property (nonatomic, assign) CGPoint       selefOrigin;

@property (nonatomic, assign) CGRect        tableViewShowFrame;

@property (nonatomic, assign) CGRect        tableViewHideFrame;

@property (nonatomic, assign) GDMenuStatus  status;

@end

@implementation GDDropMenu

- (instancetype)initOrg:(CGPoint)origin inView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.selefOrigin = origin;
        self.fatherView = view;
        self.selefSize = CGSizeMake(view.frame.size.width, view.frame.size.height-origin.y);
        self.frame = CGRectMake(origin.x, origin.y, self.selefSize.width, self.selefSize.height);
        self.backgroundColor = [UIColor clearColor];
        self.backGroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backGroundView.backgroundColor = [UIColor blackColor];
        self.backGroundView.alpha = 0.0;
        [self addSubview:self.backGroundView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.bounces = NO;
        [self addSubview:self.tableView];
        
        self.tableViewShowFrame = self.bounds;
        self.tableViewHideFrame = CGRectMake(origin.x, origin.y, self.selefSize.width, 0);
        self.tableView.frame = self.tableViewHideFrame;
        self.status = GDMenuStatusHiden;
        
        [view addSubview:self];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.delegate) {
       return [self.delegate numberOfSectionsInMenu:self];
    }else{
        return 0;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.delegate) {
        return [self.delegate menu:self titleForHeaderInSection:section];
    }else{
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.delegate) {
        return [self.delegate menu:self numberOfRowsInSection:section];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSString * title;
    if (self.delegate) {
        title = [self.delegate menu:self titleForRowAtIndexPath:indexPath];
    }else{
        title = @"";
    }
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        [self.delegate menu:self didSelectRowAtIndexPath:indexPath];
        [self show];
    }else{
        [self show];
    }
    
}

- (void)show
{
    if (self.status == GDMenuStatusHiden) {
        
        void (^complete)(BOOL) = ^(BOOL finished){
            self.status = GDMenuStatusShow;
        };
        
        void (^Animated)() = ^{
            self.hidden = NO;
            self.tableView.frame = self.tableViewShowFrame;
            self.backGroundView.alpha = 0.5;
        };
        
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.5
                            options:0
                         animations:Animated
                         completion:complete];
        [self.tableView reloadData];
    
    }
    else
    {
        void (^complete)(BOOL) = ^(BOOL finished){
            self.status = GDMenuStatusHiden;
            self.hidden = YES;
        };
        
        void (^Animated)() = ^{
            self.tableView.frame = self.tableViewHideFrame;
            self.backGroundView.alpha = 0.0;
        };
        
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.5
                            options:0
                         animations:Animated
                         completion:complete];
        
    }
}

@end
