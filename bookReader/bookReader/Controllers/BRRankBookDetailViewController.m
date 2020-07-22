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
#import "BRBookInfoViewController.h"

@interface BRRankBookDetailViewController ()

@end

@implementation BRRankBookDetailViewController

#pragma mark- private
- (void)getRankBookWtihIndex:(NSInteger )index {
    NSArray *typesArray = @[@1, @2, @5, @4, @3];
    NSInteger type = [[typesArray objectAtIndex:index] integerValue];
    kWeakSelf(self)
    [BRBookInfoModel getRankListWithType:type page:0 size:20 success:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        [self->_recordsArray addObjectsFromArray:recodes];
        [self.tableView reloadData];
    } failureBlock:^(NSError * _Nonnull error) {
        
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
    [self getRankBookWtihIndex:self.index];
}


#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRBookInfoViewController *vc = [[BRBookInfoViewController alloc] init];
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
