//
//  BRSettingViewController.m
//  bookReader
//
//  Created by Jobs on 2020/9/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSettingViewController.h"
#import "BRSettingTableViewCell.h"
#import "BRDataBaseManager.h"
#import <YYWebImage/YYWebImage.h>
#import <YYImageCache.h>


@interface BRSettingViewController () {
    NSArray *_section0Array;
}

@end

@implementation BRSettingViewController

#pragma mark- private

- (void)deleteCache {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定需要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[BRDataBaseManager sharedInstance] deleteChapterContentWithOtherBooks];
        [self deleteImageCache];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteImageCache {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjectsWithBlock:^{
        kdispatch_main_sync_safe(^{
            [self showErrorStatus:@"清除缓存成功~"];
        });
    }];

}

#pragma mark- LifeCycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
        self.headTitle = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _section0Array = @[
        @{@"icon":@"profile_list_history", @"title":@"清除缓存"},
    ];
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dict = [_section0Array objectAtIndex:indexPath.row];
      
    NSString *title = [dict objectForKey:@"title"];
    if ([title isEqualToString:@"清除缓存"]) {
        [self deleteCache];
    }
    
}

#pragma mark- UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"Identifier";
    BRSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[BRSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
    }
    NSDictionary *dict = [_section0Array objectAtIndex:indexPath.row];
        
    cell.icon = [dict objectForKey:@"icon"];
    cell.title = [dict objectForKey:@"title"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = _section0Array.count;
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBRSettingTableViewCellHeight;
}

@end
