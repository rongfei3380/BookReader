//
//  BRCategoryBooksViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRCategoryBooksViewController.h"
#import "BRBookInfoViewController.h"
#import "BRBookCategory.h"
#import "BRBookInfoModel.h"
#import "BRAPIClient.h"
#import "BRBookListTableViewCell.h"

@interface BRCategoryBooksViewController () {
    UIView *_categoryView;
    UIButton *_selectedButton;
    BRBookCategory *_selectedCategory;
}

@end

@implementation BRCategoryBooksViewController

#pragma mark- private

- (void)createCategoryViewIfNeed {
    
    NSInteger row = _categoryArray.count/7 +_categoryArray.count%7>0 ? 1:0;
    
    if (!_categoryView) {
        _categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90 +row*60)];
        _categoryView.backgroundColor = CFUIColorFromRGBAInHex(0xFFFFFF,1);
        
        UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allBtn.frame = CGRectMake(5, 10, 30, 30);
        allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [allBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
        [allBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
        [allBtn addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [_categoryView addSubview:allBtn];
        allBtn.tag = 999;
        allBtn.selected = YES;
        _selectedButton = allBtn;
    }
    
    CGFloat buttonWidth = (SCREEN_WIDTH -5*2 -30) /7;
    
    for (int i = 0; i<_categoryArray.count; i++) {
        BRBookCategory *item = [_categoryArray objectAtIndex:i];
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.tag = 1000 +i;
        itemBtn.frame = CGRectMake(40 +i%7 *buttonWidth, 10 +i/7*30, buttonWidth -5, 30);
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [itemBtn setTitle:item.categoryName forState:UIControlStateNormal];
        [itemBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
        [itemBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
        [itemBtn addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [_categoryView addSubview:itemBtn];
    }
    
    self.tableView.tableHeaderView = _categoryView;
    [self.tableView reloadData];
}

- (void)getBooksWithCategory:(BRBookCategory *)category page:(NSInteger)page{
    kWeakSelf(self)
    [BRBookInfoModel getBookListWithCategory:category.categoryId.longValue page:page size:20 sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        [self->_recordsArray addObjectsFromArray:recodes];
        if(self->_recordsArray.count){
            self.tableView.mj_footer.hidden = NO;
        }
        if (recodes.count <20 ) {
            [self toggleLoadMore:NO];
        } else {
            [self toggleLoadMore:YES];
        }
        [self endGetData];
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
        [self endGetData];
    }];
}


#pragma mark- button methods

- (void)clickCategoryButton:(UIButton *)sender {
    _selectedButton.selected = NO;
    _selectedButton = sender;
    _selectedButton.selected = YES;
    
    NSInteger selectedIndex = _selectedButton.tag -1000;
    if (selectedIndex > 0) {
        BRBookCategory *category = [_categoryArray objectAtIndex:selectedIndex];
        _selectedCategory = category;
        [self reloadGridViewDataSourceForHead];
        
    } else {
        
    }
    
    
}

#pragma mark- View LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enableTableBaseModules |= TableBaseEnableModulePullRefresh | TableBaseEnableModuleLoadmore;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createCategoryViewIfNeed];
}

#pragma mark-  setter

- (void)setCategoryArray:(NSArray *)categoryArray {
    _categoryArray = categoryArray;
    self.page = 0;
    _selectedCategory = [_categoryArray firstObject];
    [self  createCategoryViewIfNeed];
    [self getBooksWithCategory:_selectedCategory page:self.page];
    [self.tableView reloadData];
}

#pragma mark- Public: subclass implement

- (void)reloadGridViewDataSourceForHead {
    [super reloadGridViewDataSourceForHead];
    self.page = 0;
    [_recordsArray removeAllObjects];
    [self getBooksWithCategory:_selectedCategory page:self.page];
}

- (void)reloadGridViewDataSourceForFoot {
    [super reloadGridViewDataSourceForFoot];
    self.page++;
    [self getBooksWithCategory:_selectedCategory page:self.page];
}



#pragma mark- ZJScrollPageViewChildVcDelegate

- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    
}

- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    
}

- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
    
}

- (void)zj_viewDidDisappearForIndex:(NSInteger)index {
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
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
