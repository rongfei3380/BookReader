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
#import "BRSearchBookResultViewController.h"

@interface BRSearchBookViewController ()<UITextFieldDelegate> {
    UIView *_searchBackView; // 搜索框背景
    UITextField *_searchTextField; // 搜索输入框
    NSArray *_searchArray;
}

@end

@implementation BRSearchBookViewController

- (void)initDate {
    _searchArray = [[[BRDataBaseManager sharedInstance] selectSearchHistorys] mutableCopy];
}


#pragma mark- init methods

- (id)init {
    if (self = [super init]) {
        self.enableModule |= BaseViewEnableModuleHeadView;
        
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
        make.centerY.mas_equalTo(0);
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
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
    
}

#pragma mark- View LifeCycle

- (void)loadView {
    [super loadView];
    [self initSearchTextView];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.collectionView registerClass:[BRSearchCollectionViewCell class] forCellWithReuseIdentifier:@"BRSearchCollectionViewCell"];
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
        [self pushToBookListVCWithKeyWord:textField.text];
        return YES;
    }
    
    return NO;
}

#pragma mark- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *word = [_searchArray objectAtIndex:indexPath.row];
    [self pushToBookListVCWithKeyWord:word];
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

    NSString *word = [_searchArray objectAtIndex:indexPath.row];


    BRSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRSearchCollectionViewCell" forIndexPath:indexPath];
    cell.searchString = word;
    
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 40);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH -20*2 -20)/2.f, 25);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _searchArray.count;
}

#pragma mark- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 24;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    return edgeInsets;
}

@end
