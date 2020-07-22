//
//  BRBookshelfViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookshelfViewController.h"
#import "BRBookShelfLongCollectionViewCell.h"
#import "BRDataBaseManager.h"
#import "BRBookReadViewController.h"


@interface BRBookshelfViewController () {
    NSArray *_recordsArray;
}

@end

@implementation BRBookshelfViewController

#pragma mark-private

- (void)initData {
   _recordsArray =  [[[BRDataBaseManager sharedInstance] selectBookInfos] mutableCopy];
    [self.collectionView reloadData];
}

- (void)gotoReadWithBook:(BRBookInfoModel *)book {
    BRBookReadViewModel* vm = [[BRBookReadViewModel alloc] initWithBookModel:book];
    BRBookReadViewController* vc = [[BRBookReadViewController alloc] init];
    vc.viewModel = vm;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    [self.collectionView registerClass:[BRBookShelfLongCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookShelfLongCollectionViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

#pragma mark -UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BRBookShelfLongCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookShelfLongCollectionViewCell" forIndexPath:indexPath];
    
    BRBookInfoModel *item = [_recordsArray objectAtIndex:indexPath.row];
    cell.bookInfo = item;
    
    
    return cell;
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
    return CGSizeMake(SCREEN_WIDTH, kBookShelfLongCollectionViewCellHeight);
}

@end
