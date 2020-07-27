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
        self.emptyImg = [UIImage imageNamed:@"img_blank"];
        self.emptyString = @"没有书哦~~";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    if(!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _layout.minimumLineSpacing = 1;
        _layout.minimumInteritemSpacing = 1;
        //设置每个item的大小为100*100
        _layout.itemSize = CGSizeMake(SCREEN_WIDTH, 60);
    }
    CGFloat offSetY = kStatusBarHeight();
    if (self.enableModule & BaseViewEnableModuleHeadView) {
        offSetY = CGRectGetMaxY(self.headView.frame);
    }
    
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, offSetY, SCREEN_WIDTH, self.view.frame.size.height -offSetY) collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.scrollsToTop = YES;
    _collectionView.userInteractionEnabled = YES;
    _collectionView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    /**
     注册 collectionView RegisterClass : Cell And SectionHeader
     */
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionReuseViewIdentifier];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.enableModule & BaseViewEnableModuleHeadView) {
            make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
        } else {
            make.top.mas_equalTo(kStatusBarHeight());
        }
        
        make.left.right.bottom.mas_equalTo(0);
    }];
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
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    space = nil;
}
#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, 60);
}


#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {

    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = [self fetchEmptyString];
    font = [UIFont systemFontOfSize:14];
    textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [self fetchEmptyImage];
}

// 空白页面 label 和 imageview  的 布局：
//  label 页面居中Ø
// imageview 底部距离 label上方 12

//垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - [self fetchEmptyImage].size.height * 0.5;
}

//图片与文字间间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 13;
}


- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


@end

