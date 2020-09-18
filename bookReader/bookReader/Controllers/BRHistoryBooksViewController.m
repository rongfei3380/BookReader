//
//  BRHistoryBooksViewController.m
//  bookReader
//
//  Created by Jobs on 2020/9/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRHistoryBooksViewController.h"
#import "BRDataBaseManager.h"
#import "BRBookShelfLongCollectionViewCell.h"

@interface BRHistoryBooksViewController () {
    NSArray *_recordsArray;
    NSMutableDictionary *_apiBooksDict;
}

@end

@implementation BRHistoryBooksViewController

#pragma mark- private

- (void)initData {
    _recordsArray = [[[BRDataBaseManager sharedInstance] selectHistoryBookInfos] mutableCopy];
    _apiBooksDict = [[NSMutableDictionary alloc] init];
    [self.collectionView reloadData];
    
     [self getBookInfoOnShelf];
}

- (void)updateBooksInfo {
    for (BRBookInfoModel *book in _recordsArray) {
        BRBookInfoModel *apiBook = [_apiBooksDict objectForKey:book.bookId];
        
        book.lastChapterName = apiBook.lastChapterName;
        book.lastChapterId = apiBook.lastChapterId;
        book.lastupdate = apiBook.lastupdate;
        if(book.lastupdate.integerValue < apiBook.lastupdate.integerValue) {
            book.updateFlag = [NSNumber numberWithBool:YES];
        } else {
            book.updateFlag = [NSNumber numberWithBool:NO];
        }
        book.lastupdateDate = apiBook.lastupdateDate;
        
        [[BRDataBaseManager sharedInstance] saveHistoryBookInfoWithModel:book];

    }
    [self.collectionView reloadData];
}

- (void)getBookInfoOnShelf{
    
    NSMutableArray *idsArray = [NSMutableArray array];
    if (_recordsArray.count) {
        for (BRBookInfoModel *item in _recordsArray) {
            [idsArray addObject:item.bookId.stringValue];
        }
        
        NSString *ids =  [idsArray componentsJoinedByString:@","];
        kWeakSelf(self)
        [BRBookInfoModel getBookInfosShelfWithBookids:ids sucess:^(NSArray * _Nonnull recodes) {
            kStrongSelf(self)
            [self->_apiBooksDict removeAllObjects];
            for (BRBookInfoModel *book in recodes) {
                [self->_apiBooksDict setObject:book forKey:book.bookId];
            }
            [self updateBooksInfo];
            [self endGetData];
        } failureBlock:^(NSError * _Nonnull error) {
            kStrongSelf(self)
             [self endGetData];
        }];
    }
}

- (void)clickMoreBtn:(UIButton *)button {
    [[BRDataBaseManager sharedInstance] deleteHistoryBooksInfo];
    [self.collectionView reloadData];
}

#pragma mark- LifeClycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
        self.enableCollectionBaseModules = CollectionBaseEnableModulePullRefresh;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self.collectionView registerClass:[BRBookShelfLongCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookShelfLongCollectionViewCell"];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreBtn setTitle:@"清空" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.mas_equalTo(-2);
        make.right.mas_equalTo(-5);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headTitle = @"浏览历史";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

#pragma mark -UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BRBookInfoModel *item = [_recordsArray objectAtIndex:indexPath.row];
    BRBookShelfLongCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookShelfLongCollectionViewCell" forIndexPath:indexPath];
    cell.bookInfo = item;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BRBookInfoModel *item = [_recordsArray objectAtIndex:indexPath.row];
//    [self gotoReadWithBook:item];
    //    space = nil;
}
#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recordsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(SCREEN_WIDTH, kBookShelfLongCollectionViewCellHeight);
    return size;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
