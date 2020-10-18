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
    UIButton *_selectedCategoryButton;
    UIButton *_selectedOverButton;
    BRBookCategory *_selectedCategory;
    
    int _bookStatus; // 书记连载状况
}

@end

@implementation BRCategoryBooksViewController

#pragma mark- private

- (void)createCategoryViewIfNeed {
    
    NSInteger row = _categoryArray.count/4 +_categoryArray.count%4>0 ? 1:0;
    NSInteger numOfRow = 4;
    CGFloat buttonWidth = (SCREEN_WIDTH -5*2 -60) /numOfRow;
    
    
    if (!_categoryView) {
        _categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20 +row*60 +40)];
        _categoryView.backgroundColor = CFUIColorFromRGBAInHex(0xFFFFFF,1);
        
      
       
        // 分类筛选
       UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       allBtn.tag = 999;
       allBtn.frame = CGRectMake(10 , 10, 40, 30);
       allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
       [allBtn setTitle:@"全部" forState:UIControlStateNormal];
       [allBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
       [allBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
       [allBtn addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
       [_categoryView addSubview:allBtn];
       allBtn.selected = YES;
       _selectedCategoryButton = allBtn;

       for (int i = 0; i<_categoryArray.count; i++) {
           BRBookCategory *item = [_categoryArray objectAtIndex:i];
           UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           itemBtn.tag = 1000 +i;
           itemBtn.frame = CGRectMake(10 +40+5 +i%numOfRow *buttonWidth, 10 +i/numOfRow*30, buttonWidth -5, 30);
           itemBtn.titleLabel.font = [UIFont systemFontOfSize:12];
           [itemBtn setTitle:item.categoryName forState:UIControlStateNormal];
           [itemBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
           [itemBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
           [itemBtn addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
           [_categoryView addSubview:itemBtn];
       }
        
        
        // 完结 连载
        UIButton *allOverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allOverBtn.frame = CGRectMake(10 , 20 +row*60, 40, 30);
        allOverBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [allOverBtn setTitle:@"全部" forState:UIControlStateNormal];
        [allOverBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
        [allOverBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
        [allOverBtn addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        allOverBtn.tag = 1999;
        [_categoryView addSubview:allOverBtn];
        allOverBtn.selected = YES;
        _selectedOverButton = allOverBtn;
        
        UIButton *serializeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        serializeBtn.frame = CGRectMake(10 +1*45 , 20 +row*60, 40, 30);
        serializeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [serializeBtn setTitle:@"连载" forState:UIControlStateNormal];
        [serializeBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
        [serializeBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
        [serializeBtn addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        serializeBtn.tag = 2000;
        [_categoryView addSubview:serializeBtn];
        
        UIButton *overBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        overBtn.frame = CGRectMake(10 +2*45 , 20 +row*60, 40, 30);
        overBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [overBtn setTitle:@"完结" forState:UIControlStateNormal];
        [overBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
        [overBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
        [overBtn addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        overBtn.tag = 2001;
        [_categoryView addSubview:overBtn];
        
        
        
        
        self.tableView.tableHeaderView = _categoryView;
    } else {
        for (int i = 0; i<_categoryArray.count; i++) {
            BRBookCategory *item = [_categoryArray objectAtIndex:i];
            
            UIButton *itemBtn = (UIButton *)[_categoryView viewWithTag:1000 +i];
            [itemBtn setTitle:item.categoryName forState:UIControlStateNormal];
        }
    }
    
   
   
    [self.tableView reloadData];
}

- (void)getCategoryes {
    
    self.categoryArray = [self getCacheRecordsWithKey:@"BRBookCategory"];
    
    kWeakSelf(self)
    [BRBookCategory getBookCategorySucess:^(NSArray * _Nonnull maleCategoryes, NSArray * _Nonnull famaleCategory) {
        kStrongSelf(self)
        NSMutableArray *array = [maleCategoryes mutableCopy];
        if (famaleCategory.count > 0) {
            [array addObject:famaleCategory.firstObject];
        }
        [self cacheRecords:array key:@"BRBookCategory"];
        
        self.categoryArray = [array copy];
        
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}


- (void)getBooksWithCategory:(BRBookCategory *)category page:(NSInteger)page{
    
    if (page == 0 && _recordsArray.count == 0) {
        [_recordsArray removeAllObjects];
        [_recordsArray addObjectsFromArray:[self getCacheRecordsWithKey:category.categoryId.stringValue]];
        [self.tableView reloadData];
        [self showProgressMessage:@"正在获取……"];
    }
    
    kWeakSelf(self)
    [BRBookInfoModel getBookListWithCategory:category.categoryId.longValue isOver:_bookStatus page:page size:20 sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        
        [self hideProgressMessage];
        
        if (page == 0) {
            [self->_recordsArray removeAllObjects];
        }
        
        [self cacheRecords:recodes key:category.categoryId.stringValue];
        
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
        [self hideProgressMessage];
        [self showErrorMessage:error];
        [self endGetData];
    }];
}


#pragma mark- button methods

- (void)clickCategoryButton:(UIButton *)sender {
    _selectedCategoryButton.selected = NO;
    _selectedCategoryButton = sender;
    _selectedCategoryButton.selected = YES;
    
    NSInteger selectedIndex = _selectedCategoryButton.tag -1000;
    if (selectedIndex >= 0) {
        BRBookCategory *category = [_categoryArray objectAtIndex:selectedIndex];
        _selectedCategory = category;
    } else {
        _selectedCategory = nil;
    }
    
    [self reloadGridViewDataSourceForHead];
}

- (void)clickStatusButton:(UIButton *)sender {
    _selectedOverButton.selected = NO;
    _selectedOverButton = sender;
    _selectedOverButton.selected = YES;
    
    _bookStatus = sender.tag -2000;
    [self reloadGridViewDataSourceForHead];
}

#pragma mark- View LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleTitle | BaseViewEnableModuleSearch;
        self.enableTableBaseModules |= TableBaseEnableModulePullRefresh | TableBaseEnableModuleLoadmore;
        
        _bookStatus = -1;
        self.headTitle = @"分类";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirstLoad) {
        if (!_categoryArray || _categoryArray.count == 0) {
            [self  getCategoryes];
        } else {
            [self createCategoryViewIfNeed];
        }
    }
}

#pragma mark-  setter

- (void)setCategoryArray:(NSArray *)categoryArray {
    _categoryArray = categoryArray;
    if (_categoryArray.count > 0) {
        self.page = 0;
        [self  createCategoryViewIfNeed];
        [_recordsArray removeAllObjects];
        [self.tableView reloadData];
        [self getBooksWithCategory:_selectedCategory page:self.page];
    }
}

#pragma mark- Public: subclass implement

- (void)reloadGridViewDataSourceForHead {
    [super reloadGridViewDataSourceForHead];
    self.page = 0;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
