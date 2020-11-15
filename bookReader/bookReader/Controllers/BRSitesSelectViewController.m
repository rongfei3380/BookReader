//
//  BRSitesSelectViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/30.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSitesSelectViewController.h"
#import "BRSiteTableViewCell.h"

@interface BRSitesSelectViewController ()

@property(nonatomic, strong) BRSite *selectedSite;

@end

@implementation BRSitesSelectViewController

#pragma mark- private

- (void)getSelectedSiteDate {
    BRSite *site = nil;
    if (self.selectedSiteIndex >= 0) {
        if (self.selectedSiteIndex >= _sitesArray.count) {
            self.selectedSiteIndex = _sitesArray.count -1;
        }
        site = [_sitesArray objectAtIndex:self.selectedSiteIndex];
    } else {
        site = [_sitesArray firstObject];
    }
    
    site.isSelected  = [NSNumber numberWithBool:YES];
    
    _selectedSite = site;
}

- (void)getNewSites {
    kWeakSelf(self)
   [BRSite getSiteListWithBookId:self.bookId sucess:^(NSArray * _Nonnull recodes) {
       kStrongSelf(self)
       self->_sitesArray = [recodes mutableCopy];
       [self getSelectedSiteDate];
       [self endMJRefreshHeader];
       [self.tableView reloadData];
       if (self.delegate && [self.delegate respondsToSelector:@selector(sitesUpdate:)]) {
              [self.delegate sitesUpdate:self->_sitesArray];
        }
   } failureBlock:^(NSError * _Nonnull error) {
       
   }];
}

- (void)setSelectedSiteIndex:(NSInteger)selectedSiteIndex {
    _selectedSiteIndex = selectedSiteIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sitesSelectViewController:)]) {
           [self.delegate sitesSelectViewController:selectedSiteIndex];
    }
}

#pragma mark- lifeCycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleTitle | BaseViewEnableModuleBackBtn;
        self.enableTableBaseModules = TableBaseEnableModulePullRefresh;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headTitle = @"选择来源";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getSelectedSiteDate];
    if(self.isFirstLoad) {
        [self getNewSites];
    }
}


#pragma mark- Public: subclass implement

- (void)reloadGridViewDataSourceForHead {
    [self getNewSites];
}


#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    _selectedSite.isSelected = [NSNumber numberWithBool:NO];
    
    BRSite *site = [_sitesArray objectAtIndex:indexPath.row];
    site.isSelected = [NSNumber numberWithBool:YES];
    _selectedSite = site;
    
    [self.tableView reloadData];
    
    self.selectedSiteIndex = indexPath.row;
   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBRSiteTableViewCellHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"Identifier";
    BRSiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[BRSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
    }
    BRSite *site = [_sitesArray objectAtIndex:indexPath.row];
    cell.site = site;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sitesArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
