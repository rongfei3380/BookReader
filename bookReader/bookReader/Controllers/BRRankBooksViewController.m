//
//  BRRankBooksViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRRankBooksViewController.h"
#import "BRBookInfoModel.h"
#import "BRRecommendCollectionReusableView.h"
#import "BRRecommendBigCollectionViewCell.h"
#import "BRRecommendCollectionViewCell.h"
#import "BRBookInfoModel.h"
#import "BRRankBookDetailViewController.h"

@interface BRRankBooksViewController ()<BRRecommendCollectionReusableViewDelegate>{
    NSArray *_rotationArray;
    NSArray *_recommendArray;
}

@end

@implementation BRRankBooksViewController

- (void)getRecommend {
    if (!_rotationArray || _rotationArray.count == 0) {
       self->_rotationArray =  [[self getCacheRecordsWithKey:@"rotationArray"] mutableCopy];
        [self.collectionView reloadData];
    }
    
    if (!_recommendArray || _recommendArray.count == 0) {
        self->_recommendArray = [ [self getCacheRecordsWithKey:@"recommendArray"] mutableCopy];
        [self.collectionView reloadData];
    }
    
    
    kWeakSelf(self)
    [BRBookInfoModel getRecommendSuccess:^(NSArray * _Nonnull rotationArray, NSArray * _Nonnull recommendArray) {
        self->_rotationArray = [rotationArray mutableCopy];
        self->_recommendArray = [recommendArray mutableCopy];
        
        [self cacheRecords:rotationArray key:@"rotationArray"];
        [self cacheRecords:recommendArray key:@"recommendArray"];
        
        [self.collectionView reloadData];
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[BRRecommendCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendCollectionReusableView"];
    [self.collectionView registerClass:[BRRecommendBigCollectionViewCell class] forCellWithReuseIdentifier:@"BRRecommendBigCollectionViewCell"];
    [self.collectionView registerClass:[BRRecommendCollectionViewCell class] forCellWithReuseIdentifier:@"BRRecommendCollectionViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirstLoad) {
         [self getRecommend];
    }
}


#pragma mark- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BRBookInfoModel *model = [_recommendArray objectAtIndex:indexPath.row];
    [self goBookInfoViewWIthBook:model];
}


#pragma mark- UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    BRRecommendCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendCollectionReusableView" forIndexPath:indexPath];
    view.delegate = self;
    view.booksArray = _rotationArray;
    
    return view;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BRBookInfoModel *model = [_recommendArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        BRRecommendBigCollectionViewCell *bigCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRRecommendBigCollectionViewCell" forIndexPath:indexPath];
        
        bigCell.bookInfo = model;
        
        return bigCell;
        
        
    } else {
        BRRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRRecommendCollectionViewCell" forIndexPath:indexPath];
        cell.bookInfo = model;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH -20*2, 200);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH -20*2, 160);
    } else  {
        return CGSizeMake(96, 160);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recommendArray.count;
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


#pragma mark- BRRecommendCollectionReusableViewDelegate

- (void)recommendCollectionReusableViewActionButtonsClick:(NSInteger )index {
    BRRankBookDetailViewController *vc = [[BRRankBookDetailViewController alloc] init];
    vc.index = index;
    vc.headTitle = @"排行榜";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cycleScrollViewDidSelectItemAtIndex:(NSInteger )index {
    BRBookInfoModel *model = [_recommendArray objectAtIndex:index];
    [self goBookInfoViewWIthBook:model];
}

@end
