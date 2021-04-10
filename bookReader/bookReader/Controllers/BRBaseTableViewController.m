//
//  BRBaseTableViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "ZJScrollPageViewDelegate.h"

@interface BRBaseTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BRBaseTableViewController

#pragma mark- Super

- (id)init {
    if (self = [super init]) {
        _recordsArray = [NSMutableArray array];
//        self.emptyImg = [UIImage imageNamed:@"img_blank"];
//        self.emptyString = @"没有书哦~~";
    }
    return self;
}

- (void)loadView {
    [super loadView];

    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_WIDTH,self.view.frame.size.height -CGRectGetMaxY(self.headView.frame));
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.enableModule & BaseViewEnableModuleHeadView) {
            if (!self.ischildVC) {
                make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
            } else {
                make.top.offset(0);
            }
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

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {

    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = [self fetchEmptyString];
    font = [UIFont systemFontOfSize:14];
    textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [self fetchEmptyImage];
}

// 空白页面 label 和 imageview  的 布局：
//  label 页面居中Ø
// imageview 底部距离 label上方 12

//垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - [self fetchEmptyImage].size.height * 0.5;
}

//图片与文字间间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 13;
}


- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}



@end
