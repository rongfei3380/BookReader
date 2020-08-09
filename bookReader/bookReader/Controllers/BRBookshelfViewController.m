//
//  BRBookshelfViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookshelfViewController.h"
#import "BRBookShelfLongCollectionViewCell.h"
#import "BRBookShelfCollectionViewCell.h"
#import "BRDataBaseManager.h"
#import "BRBookReadViewController.h"
#import "BRSearchBookViewController.h"
#import "FTPopOverMenu.h"
#import "BRBooksManagerViewController.h"
#import "GVUserDefaults+BRUserDefaults.h"
#import "BRDataBaseManager.h"

@interface BRBookshelfViewController () {
    NSArray *_recordsArray;
    NSMutableDictionary *_apiBooksDict;
    
    UILabel *_countLabel;
}

@property(nonatomic, assign) BOOL isShelf; // 是否为书架模式

@end

@implementation BRBookshelfViewController

#pragma mark-private

- (void)initData {
    self.emptyString = @"书架还是空的哦～";
   _recordsArray =  [[[BRDataBaseManager sharedInstance] selectBookInfos] mutableCopy];
    _apiBooksDict = [[NSMutableDictionary alloc] init];
    self.isShelf = BRUserDefault.isShelfStyle;
    [self.collectionView reloadData];
    
    [self getBookInfoOnShelf];
}

- (void)gotoReadWithBook:(BRBookInfoModel *)book {
    BRBookReadViewModel* vm = [[BRBookReadViewModel alloc] initWithBookModel:book];
    BRBookReadViewController* vc = [[BRBookReadViewController alloc] init];
    vc.viewModel = vm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoBooksManager {
    BRBooksManagerViewController *vc = [[BRBooksManagerViewController alloc] init];
    vc.headTitle = @"书籍管理";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateBooksInfo {
    for (BRBookInfoModel *book in _recordsArray) {
        BRBookInfoModel *apiBook = [_apiBooksDict objectForKey:book.bookId];
        
        book.lastChapterName = apiBook.lastChapterName;
        book.lastChapterId = apiBook.lastChapterId;
        
        BRBookRecord* model = [[BRDataBaseManager sharedInstance] selectBookRecordWithBookId:book.bookId.stringValue];
            /* 有阅读记录*/
           if (model){
               book.chapterIndexStatus = [NSString stringWithFormat:@"已读%ld章", model.chapterIndex+1];
           }else{
               book.chapterIndexStatus = @"未读";
           }
                       
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
            
        }];
    }
}

#pragma Life cycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableCollectionBaseModules = CollectionBaseEnableModulePullRefresh;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    [self.collectionView registerClass:[BRBookShelfLongCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookShelfLongCollectionViewCell"];
    [self.collectionView registerClass:[BRBookShelfCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookShelfCollectionViewCell"];
    
    self.collectionView.clipsToBounds = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(kStatusBarHeight()*(-1), 0, 0, 0);
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(kStatusBarHeight() +2);
        make.right.mas_equalTo(-5);
    }];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(kStatusBarHeight() +2);
        make.right.mas_equalTo(moreBtn.mas_left).offset(-5);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

#pragma mark- setter
- (void)setIsShelf:(BOOL)isShelf {
    _isShelf = isShelf;
    BRUserDefault.isShelfStyle = _isShelf;
    [self.collectionView reloadData];
}



- (void)reloadGridViewDataSourceForHead {
    [self getBookInfoOnShelf];
}


#pragma mark- button Methods

- (void)clickSearchBtn:(UIButton *)sender {
    BRSearchBookViewController *vc = [[BRSearchBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickMoreBtn:(UIButton *)button {
    NSArray *menuNameArray = @[@"书籍管理", (BRUserDefault.isShelfStyle ? @"列表模式"  : @"书架模式")];
    NSArray *menuImageNameArray = @[@"ico_bookshelf_menu",@"icon_bookshelf_menu"];

    FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
    config.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    config.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    config.borderColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    config.separatorColor = [UIColor clearColor];
    config.shadowColor = CFUIColorFromRGBAInHex(0x000000, 1);
    config.borderWidth = 0.5f;
    
    config.borderColor = UIColor.whiteColor;
    kWeakSelf(self)
    [FTPopOverMenu showForSender:button
                   withMenuArray:menuNameArray
                      imageArray:menuImageNameArray
                   configuration:config
                       doneBlock:^(NSInteger selectedIndex) {
        kStrongSelf(self)
        if (selectedIndex == 0) {
            [self gotoBooksManager];
        } else if (selectedIndex == 1) {
            self.isShelf = !self.isShelf;
        }
                           
                           
                       } dismissBlock:^{
                           
                       }];
}

#pragma mark -UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BRBookInfoModel *item = [_recordsArray objectAtIndex:indexPath.row];

    if (self.isShelf) {
        BRBookShelfCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookShelfCollectionViewCell" forIndexPath:indexPath];
        cell.bookInfo = item;
        return cell;
    } else {
        BRBookShelfLongCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookShelfLongCollectionViewCell" forIndexPath:indexPath];
        cell.bookInfo = item;
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BRBookInfoModel *item = [_recordsArray objectAtIndex:indexPath.row];
    [self gotoReadWithBook:item];
    //    space = nil;
}
#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recordsArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionReuseViewIdentifier forIndexPath:indexPath];

        UIImageView *bgImgView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"img_bg_bookshelf"]];
        [view addSubview:bgImgView];
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.bottom.mas_offset(0);
        }];
        
        return view;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionReuseViewFooterIdentifier forIndexPath:indexPath];
        if (!_countLabel) {
            _countLabel = [[UILabel alloc] init];
            _countLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
            _countLabel.font = [UIFont systemFontOfSize:12];
            _countLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_countLabel];
            [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_offset(0);
                make.height.mas_offset(15);
                make.left.right.mas_offset(0);
            }];
        }
        
        _countLabel.text = [NSString stringWithFormat:@"- 您的书架中共%ld本书 -", _recordsArray.count];
        
        return view;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionReuseViewIdentifier forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*(152/375.f));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (_recordsArray.count) {
        return CGSizeMake(SCREEN_WIDTH, 60);
    } else {
        return CGSizeMake(SCREEN_WIDTH,0);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if (self.isShelf) {
        size = CGSizeMake(90, 120+50);
    } else {
        size = CGSizeMake(SCREEN_WIDTH, kBookShelfLongCollectionViewCellHeight);
    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.isShelf) {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 15;
//}

@end
