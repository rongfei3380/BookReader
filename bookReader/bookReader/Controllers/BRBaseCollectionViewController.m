//
//  BRCollectionViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/8.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseCollectionViewController.h"
#import <MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


NSString * const kCollectionViewCellIdentifier = @"collectionViewCellIdentifier";
NSString * const kCollectionReuseViewIdentifier = @"collectionViewResuseView";


@interface BRBaseCollectionViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
}

@end

@implementation BRBaseCollectionViewController

#pragma mark - super

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        self.enableCollectionBaseModules = CollectionBaseEnableModuleNone;
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    if(!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    
//    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds];
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
//    _collectionView.scrollsToTop = YES;
//    _collectionView.userInteractionEnabled = YES;
//    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.alwaysBounceVertical = YES;
//    /**
//     注册 collectionView RegisterClass : Cell And SectionHeader
//     */
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
//    
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionReuseViewIdentifier];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}


#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
//    text = [self fetchEmptyString];
    font = [UIFont boldSystemFontOfSize:12];
//    textColor = LX_UIColorFromRGBAInHex(0x999999, 1);
    textColor = [UIColor redColor];
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@""];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}

// 空白页面 label 和 imageview  的 布局：
//  label 页面居中
// imageview 底部距离 label上方 12

//垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0;
}

//图片与文字间间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 12;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


@end

