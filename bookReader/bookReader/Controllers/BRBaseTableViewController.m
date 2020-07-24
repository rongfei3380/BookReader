//
//  BRBaseTableViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BRBaseTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BRBaseTableViewController

#pragma mark- Super

- (id)init {
    if (self = [super init]) {
        _recordsArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];

    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_WIDTH,self.view.frame.size.height -CGRectGetMaxY(self.headView.frame));
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.enableModule & BaseViewEnableModuleHeadView) {
            make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
        } else {
            make.top.offset(0);
        }
        make.left.right.bottom.offset(0);
    }];
    
    if (_enableTableBaseModules & TableBaseEnableModulePullRefresh) {
        kWeakSelf(self)
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           //Call this Block When enter the refresh status automatically
            kStrongSelf(self)
            [self reloadGridViewDataSourceForHead];
        }];
    }
    
    if (_enableTableBaseModules & TableBaseEnableModuleLoadmore) {
        kWeakSelf(self)
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            kStrongSelf(self)
            [self reloadGridViewDataSourceForFoot];
        }];
        // 没数据时影响美观先隐藏
        self.tableView.mj_footer.hidden = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark- Public : subclass implement

- (void)reloadGridViewDataSourceForHead {
    if (_tableView.mj_header.isRefreshing) {
        return;
    }
}

- (void)endMJRefreshHeader {
    [_tableView.mj_header endRefreshing];
}

- (void)reloadGridViewDataSourceForFoot {
    if (_tableView.mj_footer.isRefreshing) {
        return;
    }
}

- (void)endMJRefreshFooter {
    [_tableView.mj_footer endRefreshing];
}

- (void)toggleLoadMore:(BOOL)needLoadMore {
    // 使用 MJRefresh 结束 loadMore
    if (needLoadMore == NO) {
        _tableView.mj_footer.hidden = YES;
        if (self.enableTableBaseModules & TableBaseEnableModuleLoadmore) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } else {
        _tableView.mj_footer.hidden = NO;
        [_tableView.mj_footer endRefreshing];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)endGetData {
    [self endMJRefreshHeader];
    [self endMJRefreshFooter];
    [self.tableView reloadData];
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark- UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
