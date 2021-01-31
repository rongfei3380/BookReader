//
//  BRRankBookDetailViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRRankBookDetailViewController.h"
#import "BRBookInfoModel.h"
#import "BRBookListTableViewCell.h"
#import "BRBookInfoCollectionViewController.h"

@interface BRRankBookDetailViewController () {
    NSInteger _page;
    NSURLSessionDataTask *_rankListTask;
}

@end

@implementation BRRankBookDetailViewController

#pragma mark- private

- (void)getRankBookWtihIndex:(NSInteger )index page:(NSInteger )page {
    NSArray *typesArray = @[@1, @2, @5, @4, @3];
    NSInteger type = [[typesArray objectAtIndex:index] integerValue];
    
    if (self.isFirstLoad && page == 0) {
       NSArray *cache = [self getCacheRecordsWithKey:[NSString stringWithFormat:@"%ld", type]];
        [self->_recordsArray addObjectsFromArray:cache];
        [self endGetData];

    }
    
    kWeakSelf(self)
    _rankListTask =
    [BRBookInfoModel getRankListWithType:type page:_page size:20 success:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        [self cacheRecords:recodes key:[NSString stringWithFormat:@"%ld", type]];
        if(self->_page == 0) {
            [self->_recordsArray removeAllObjects];
        }
        
        [self->_recordsArray addObjectsFromArray:recodes];
        [self toggleLoadMore:!(recodes.count<20)];
        [self endGetData];
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
        [self endGetData];
    }];

}

#pragma mark- setter



#pragma mark- View Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
        
        self.enableTableBaseModules |= TableBaseEnableModulePullRefresh | TableBaseEnableModuleLoadmore;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getRankBookWtihIndex:self.index page:_page];
}

- (void)dealloc {
    [_rankListTask cancel];
}

#pragma mark-: subclass implement
- (void)reloadGridViewDataSourceForHead {
    [super reloadGridViewDataSourceForHead];
    [_rankListTask cancel];
    _page = 0;
    [_recordsArray removeAllObjects];
    [self getRankBookWtihIndex:self.index page:_page];
}

- (void)reloadGridViewDataSourceForFoot {
    [super reloadGridViewDataSourceForFoot];
    _page++;
    [self getRankBookWtihIndex:self.index page:_page];
}


#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BRBookInfoCollectionViewController *vc = [[BRBookInfoCollectionViewController alloc] init];
    BRBookInfoModel *item = [_recordsArray objectAtIndex:indexPath.row];
    vc.bookInfo = item;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBookListTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"Identifier";
      BRBookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
      if(cell == nil) {
          cell = [[BRBookListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
      }
    
        BRBookInfoModel *item = [_recordsArray objectAtIndex:indexPath.row];
        cell.bookInfo = item;
      return cell;
}

@end
