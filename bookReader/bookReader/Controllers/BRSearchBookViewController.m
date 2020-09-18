//
//  BRSearchBookViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSearchBookViewController.h"
#import "BRDataBaseManager.h"
#import "BRSearchCollectionViewCell.h"
#import "BRBookListCollectionViewCell.h"
#import "BRSearchBookResultViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BRBookInfoViewController.h"

@interface BRSearchBookViewController ()<UITextFieldDelegate> {
    UIView *_searchBackView; // 搜索框背景
    UITextField *_searchTextField; // 搜索输入框
    NSArray *_searchArray;
    NSInteger _page;
    BOOL _isSearchResult;
    NSMutableArray *_searchResultArray;
    NSString *_keyWords;
}

@end

@implementation BRSearchBookViewController

#pragma mark- Private

- (void)initDate {
    _searchArray = [[[BRDataBaseManager sharedInstance] selectSearchHistorys] mutableCopy];
}


- (void)searchBookWithName:(NSString *)keyWord page:(NSInteger )page {
    
    if (page == 0) {
        [_searchResultArray removeAllObjects];
    }
    
    kWeakSelf(self)
    [BRBookInfoModel searchBookWithName:keyWord page:page size:20 sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        self->_isSearchResult = YES;
        [self hideProgressMessage];
        [self->_searchResultArray addObjectsFromArray:recodes];
        [self.collectionView reloadData];
        
        [self endGetData];
        if (recodes.count == 0 ) {
            [self showErrorStatus:@"未搜索到该书籍"];
        }
        
       if (recodes.count <20 ) {
            [self toggleLoadMore:NO];
        } else {
            [self toggleLoadMore:YES];
        }
        
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self endGetData];
        [self hideProgressMessage];
        [self showErrorMessage:error];
    }];
}

#pragma mark- Public: subclass implement

- (void)reloadGridViewDataSourceForHead {
    _page = 0;
    [self searchBookWithName:_keyWords page:_page];
}

- (void)reloadGridViewDataSourceForFoot {
    _page++;
    [self searchBookWithName:_keyWords page:_page];
}

#pragma mark- init methods

- (id)init {
    if (self = [super init]) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleTitle;
        self.enableCollectionBaseModules = CollectionBaseEnableModuleLoadmore | CollectionBaseEnableModulePullRefresh;
        _searchResultArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)initSearchTextView {
    _searchBackView = [[UIView alloc] init];
    _searchBackView.backgroundColor = CFUIColorFromRGBAInHex(0xF2F2F2, 1);
    _searchBackView.layer.cornerRadius = 14;
    _searchBackView.clipsToBounds = YES;
    [self.headView addSubview:_searchBackView];
    [_searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(28);
        make.right.mas_equalTo(-65);
    }];


    _searchTextField = [[UITextField alloc] init];
//    [_searchTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    _searchTextField.placeholder = @"请输入书名和作者搜索";
    _searchTextField.delegate = self;
    _searchTextField.font = [UIFont systemFontOfSize:14];
    _searchTextField.backgroundColor = CFUIColorFromRGBAInHex(0xF2F2F2, 1);
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchBackView addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [self.headView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-2);
        make.width.mas_equalTo(40);
    }];
    
}

#pragma mark- View LifeCycle

- (void)loadView {
    [super loadView];
    [self initSearchTextView];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.collectionView registerClass:[BRSearchCollectionViewCell class] forCellWithReuseIdentifier:@"BRSearchCollectionViewCell"];
    
    [self.collectionView registerClass:[BRBookListCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookListCollectionViewCell"];
    
    self.collectionView.emptyDataSetSource = nil;
    self.collectionView.emptyDataSetDelegate = nil;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDate];
}

#pragma mark- button methods

- (void)clickCancelBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToBookListVCWithKeyWord:(NSString*)kw {
    if (!kStringIsEmpty(kw)){
        BRSearchBookResultViewController *vc = [[BRSearchBookResultViewController alloc] init];
        vc.keyWords = kw;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!kStringIsEmpty(textField.text)){
        [[BRDataBaseManager sharedInstance] saveSearchHistoryWithName:textField.text];
//        [self pushToBookListVCWithKeyWord:textField.text];
        [_searchTextField resignFirstResponder];
        
        [self showProgressMessage:@"正在搜索~~"];
        _page = 0;
        _keyWords = textField.text;
        [_searchResultArray removeAllObjects];
        [self searchBookWithName:textField.text page:0];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    _isSearchResult = NO;
    _keyWords = nil;
    [_searchResultArray removeAllObjects];
    [self.collectionView reloadData];
    return YES;
}

#pragma mark- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *word = [_searchArray objectAtIndex:indexPath.row];
        [self showProgressMessage:@"正在搜索~~"];
        _page = 0;
        _searchTextField.text = word;
        _keyWords = word;
        [self searchBookWithName:word page:0];
    } else if (indexPath.section == 1) {
        BRBookInfoModel *book = [_searchResultArray objectAtIndex:indexPath.row];
        BRBookInfoViewController *vc = [[BRBookInfoViewController alloc] init];
        vc.bookInfo = book;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark- UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    title.font = [UIFont boldSystemFontOfSize:15];
    title.text = @"历史搜索";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];
    
    return view;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        NSString *word = [_searchArray objectAtIndex:indexPath.row];
        BRSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRSearchCollectionViewCell" forIndexPath:indexPath];
        cell.searchString = word;
        return cell;
    } else if (indexPath.section == 1) {
        BRBookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookListCollectionViewCell" forIndexPath:indexPath];
        BRBookInfoModel *book = [_searchResultArray objectAtIndex:indexPath.row];
        
        cell.bookInfo = book;
        
        return cell;
    }
    
        
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    if (section == 0) {
        if (_isSearchResult) {
            size = CGSizeMake(0, 0);
        } else  {
            size = CGSizeMake(SCREEN_WIDTH, 40);
        }
    } else if (section == 1) {
        size = CGSizeMake(0, 0);
    }
    return size;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if (indexPath.section == 0) {
        size = CGSizeMake((SCREEN_WIDTH -20*2 -20)/2.f, 25);
    } else if (indexPath.section == 1) {
        size = CGSizeMake(SCREEN_WIDTH, kBookListCollectionViewCellHeight);
    }
    
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (section == 0) {
        if (_isSearchResult) {
            number = 0;
        } else {
            number = _searchArray.count;
        }
        
    } else {
        number = _searchResultArray.count;
    }
    return number;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

#pragma mark- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat height = 0;
    if (section == 0) {
        if (_isSearchResult) {
            height = 0;
        } else {
            height = 24;
        }
    }
    return height;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat space = 0;
    if (section == 0) {
        space = 5;
    } else {
        space = 0;
    }
    
    return space;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    return edgeInsets;
}

@end
