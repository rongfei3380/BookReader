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
#import "BRSearchBookViewController.h"
#import "BRRecommendSectionHeaderCollectionReusableView.h"

@interface BRRankBooksViewController ()<BRRecommendCollectionReusableViewDelegate>{
    NSArray *_rotationArray;
    NSArray *_recommendArray;
    NSArray *_hotArray;
    NSArray *_endArray;
    NSArray *_likeArray;
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
        [self showProgressMessage:@"正在获取……"];
    }
    
    
    kWeakSelf(self)
    [BRBookInfoModel getRecommendSuccess:^(NSArray * _Nonnull rotationArray, NSArray * _Nonnull recommendArray, NSArray * _Nonnull hotArray, NSArray * _Nonnull endArray, NSArray *_Nonnull likeArray) {
        self->_rotationArray = [rotationArray mutableCopy];
        self->_recommendArray = [recommendArray mutableCopy];
        self->_hotArray = [hotArray mutableCopy];
        self->_endArray = [endArray mutableCopy];
        self->_likeArray = [likeArray mutableCopy];
        
        [self cacheRecords:rotationArray key:@"rotationArray"];
        [self cacheRecords:recommendArray key:@"recommendArray"];
        [self cacheRecords:hotArray key:@"hotArray"];
        [self cacheRecords:endArray key:@"endArray"];
        [self cacheRecords:likeArray key:@"likeArray"];
        
        [self.collectionView reloadData];
        [self hideBookProgressMessage];
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self hideBookProgressMessage];
        [self showErrorMessage:error];
    }];
    
}



#pragma mark- view lifeCycle
- (id)init {
    self = [super init];
    if (self) {
//        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleTitle ;
        
        self.headTitle = @"排行";
    }
    return self;
}
- (void)loadView {
    [super loadView];
//    UIImageView *bgImgView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bg_rank"]];
//    [self.view insertSubview:bgImgView belowSubview:self.collectionView];
//    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_offset(0);
//        make.top.mas_offset(0);
//        make.height.mas_equalTo(SCREEN_WIDTH*(200.f/375.f));
//    }];
//    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[BRRecommendCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendCollectionReusableView"];
    [self.collectionView registerClass:[BRRecommendSectionHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendSectionHeaderCollectionReusableView"];
    
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
    BRBookInfoModel *model = nil;
    
    if (indexPath.section == 0) {
        model = [_recommendArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        model = [_hotArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        model = [_endArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 3) {
        model = [_likeArray objectAtIndex:indexPath.row];
    }
    [self goBookInfoViewWIthBook:model];
    
}


#pragma mark- UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BRRecommendCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendCollectionReusableView" forIndexPath:indexPath];
        view.delegate = self;
        view.booksArray = _rotationArray;
//        [view setSectionHeader:@"重磅推荐"];
        return view;
    } else if (indexPath.section == 1) {
        BRRecommendSectionHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendSectionHeaderCollectionReusableView" forIndexPath:indexPath];
        [view setSectionHeader:@"抖音热书"];
        return view;
    } else if (indexPath.section == 2) {
        BRRecommendSectionHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendSectionHeaderCollectionReusableView" forIndexPath:indexPath];
        [view setSectionHeader:@"完本精选"];
        return view;
    } else if (indexPath.section == 3) {
        BRRecommendSectionHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BRRecommendSectionHeaderCollectionReusableView" forIndexPath:indexPath];
        [view setSectionHeader:@"女生最爱"];
        return view;
    } else {
        return nil;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
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
    } else if (indexPath.section == 1) {
        BRBookInfoModel *model = [_hotArray objectAtIndex:indexPath.row];
        BRRecommendBigCollectionViewCell *bigCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRRecommendBigCollectionViewCell" forIndexPath:indexPath];
        
        bigCell.bookInfo = model;
        
        return bigCell;
    } else if (indexPath.section == 2) {
        BRBookInfoModel *model = [_endArray objectAtIndex:indexPath.row];
        BRRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRRecommendCollectionViewCell" forIndexPath:indexPath];
        cell.bookInfo = model;
        return cell;
    } else if (indexPath.section == 3) {
        BRBookInfoModel *model = [_likeArray objectAtIndex:indexPath.row];
        BRRecommendBigCollectionViewCell *bigCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRRecommendBigCollectionViewCell" forIndexPath:indexPath];
        bigCell.bookInfo = model;
        return bigCell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH -15*2, kRecommendCollectionReusableViewHeight);
    } else {
        return CGSizeMake(SCREEN_WIDTH -15*2, kBRRecommendSectionHeaderCollectionReusableViewHeight);
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH -15*2, kBRRecommendBigCollectionViewCellHeight);
        } else  {
            return CGSizeMake(75, 100 +46);
        }
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH -15*2, kBRRecommendBigCollectionViewCellHeight);
    } else if (indexPath.section == 2) {
        return CGSizeMake(75, 100 +46);
    } else if (indexPath.section == 3) {
        return CGSizeMake(SCREEN_WIDTH -15*2, kBRRecommendBigCollectionViewCellHeight);
    } else {
        return CGSizeMake(SCREEN_WIDTH -15*2, kBRRecommendBigCollectionViewCellHeight);
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (section == 0) {
        rows = _recommendArray.count;
    } else if (section == 1){
        rows = _hotArray.count;
    } else if (section == 2){
        rows = _endArray.count;
    } else if (section == 3){
        rows = _likeArray.count;
    }
    return rows;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

#pragma mark- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat space = (SCREEN_WIDTH -15*2 -75*4) /3.f ;
    return space;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    return edgeInsets;
}


#pragma mark- BRRecommendCollectionReusableViewDelegate

- (void)recommendCollectionReusableViewActionButtonsClick:(NSInteger )index title:(NSString *)title{
    BRRankBookDetailViewController *vc = [[BRRankBookDetailViewController alloc] init];
    vc.index = index;
    vc.headTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cycleScrollViewDidSelectItemAtIndex:(NSInteger )index {
    BRBookInfoModel *model = [_rotationArray objectAtIndex:index];
    [self goBookInfoViewWIthBook:model];
}

- (void)recommendCollectionReusableViewTapSearch {
    BRSearchBookViewController *vc = [[BRSearchBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
