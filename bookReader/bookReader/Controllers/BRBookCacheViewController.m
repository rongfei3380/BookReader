//
//  BRBookCacheViewController.m
//  bookReader
//
//  Created by Jobs on 2021/1/11.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookCacheViewController.h"
#import "BRDataBaseCacheManager.h"
#import "BRCacheTask.h"
#import "BRBookCacheTableViewCell.h"

@interface BRBookCacheViewController ()<BRBookCacheTableViewCellDelegate>

@property(nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation BRBookCacheViewController
- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
        self.headTitle = @"小说缓存";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dict = [BRDataBaseCacheManager sharedInstance].allCacheTaskes;
    [self.tableView reloadData];
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark- UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"BRBookCacheTableViewCell";
    BRBookCacheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[BRBookCacheTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
        cell.delegate = self;
    }
    NSString *key = [_dict.allKeys objectAtIndex:indexPath.row];
    BRCacheTask *cacheTask = [_dict objectForKey:key];
    cell.cacheTask = cacheTask;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = _dict.allKeys.count;
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBRBookCacheTableViewCellHeight;
}

#pragma marl-BRBookCacheTableViewCellDelegate

- (void)bookCacheTableViewCellClickControlButton:(UIButton *)button cacheTask:(BRCacheTask *)cacheTask {
    if (!button.selected) {
        [[BRDataBaseCacheManager sharedInstance] resume:cacheTask completed:^{
            cacheTask.state = BRCacheTaskStateDownloading;
            [self.tableView reloadData];
        }];
    } else {
        [[BRDataBaseCacheManager sharedInstance] suspended:cacheTask completed:^{
            cacheTask.state = BRCacheTaskStateWillResume;
            [self.tableView reloadData];
        }];

    }
}

- (void)bookCacheTableViewCellClickDeleteButton:(UIButton *)button cacheTask:(BRCacheTask *)cacheTask {
    [[BRDataBaseCacheManager sharedInstance] cancel:cacheTask completed:^{
        _dict = [BRDataBaseCacheManager sharedInstance].allCacheTaskes;
        [self.tableView reloadData];
    }];
}

@end
