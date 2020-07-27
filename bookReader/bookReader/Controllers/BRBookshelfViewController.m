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

@interface BRBookshelfViewController () {
    NSArray *_recordsArray;
}

@property(nonatomic, assign) BOOL isShelf; // 是否为书架模式

@end

@implementation BRBookshelfViewController

#pragma mark-private

- (void)initData {
    self.emptyString = @"书架还是空的哦～";
   _recordsArray =  [[[BRDataBaseManager sharedInstance] selectBookInfos] mutableCopy];
    self.isShelf = BRUserDefault.isShelfStyle;
    [self.collectionView reloadData];
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

#pragma Life cycle

- (void)loadView {
    [super loadView];
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    [self.collectionView registerClass:[BRBookShelfLongCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookShelfLongCollectionViewCell"];
    [self.collectionView registerClass:[BRBookShelfCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookShelfCollectionViewCell"];
    
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
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionReuseViewIdentifier forIndexPath:indexPath];

    UIImageView *bgImgView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"img_bg_bookshelf"]];
    [view addSubview:bgImgView];
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.bottom.mas_offset(0);
    }];
    
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*(152/375.f));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if (self.isShelf) {
        size = CGSizeMake(90, 120+60);
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

@end
