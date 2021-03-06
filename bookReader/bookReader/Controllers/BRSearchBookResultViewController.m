//
//  BRSearchBookResultViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSearchBookResultViewController.h"
#import "BRBookInfoModel.h"
#import "BRBookListTableViewCell.h"
#import "BRBookInfoCollectionViewController.h"

@interface BRSearchBookResultViewController () {
    NSURLSessionDataTask *_searchTask;
}

@end

@implementation BRSearchBookResultViewController

#pragma mark- private
- (void)searchBookWithName:(NSString *)keyWord page:(NSInteger )page {
    kWeakSelf(self)
    _searchTask =
    [BRBookInfoModel searchBookWithName:keyWord page:page size:20 sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        [self->_recordsArray addObjectsFromArray:recodes];
        [self.tableView reloadData];
        
        if (recodes.count == 0 ) {
            [self showErrorStatus:@"未搜索到该书籍"];
        }
        
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
    }];
}

#pragma mark- setter



#pragma mark- View Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self searchBookWithName:self.keyWords page:0];
    self.headTitle = self.keyWords;
}

- (void)dealloc {
    [_searchTask cancel];
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
