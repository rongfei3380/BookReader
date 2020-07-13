//
//  BRBaseTableViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum _TableBaseEnableModule {
    TableBaseEnableModuleNone = 0,
    TableBaseEnableModulePullRefresh = 1 << 0,     // 下拉刷新
    TableBaseEnableModuleLoadmore = 1 << 1,     // 加载更多
    TableBaseEnableModuleLoadmoreOverFlag = 1 << 2,     // 没有加载更多的标识
} TableBaseEnableModule;

/// 有tableview的页面基类 支持下拉刷新与loadmore
@interface BRBaseTableViewController : BRBaseViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *_recordsArray;  // 数据源
}

@property (nonatomic, assign) TableBaseEnableModule enableTableBaseModules;
@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
