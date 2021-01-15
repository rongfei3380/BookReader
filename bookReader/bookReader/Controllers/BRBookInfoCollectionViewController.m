//
//  BRBookInfoCollectionViewController.m
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookInfoCollectionViewController.h"
#import "BRBookInfoViewController.h"
#import "BRDataBaseManager.h"
#import "BRDataBaseCacheManager.h"

#import "BRBookListCollectionViewCell.h"
#import "BRBookInfoActionsCollectionViewCell.h"
#import "BRBookInfoDescCollectionViewCell.h"
#import "BRBookInfoSitesCollectionViewCell.h"

#import "BRBookReadViewModel.h"
#import "BRBookReadViewController.h"
#import "BRChaptersView.h"
#import "BRSitesSelectViewController.h"

@interface BRBookInfoCollectionViewController ()<BRBookInfoActionsCollectionViewCellDelegate, BRSitesSelectViewControllerDelegate, BRBookInfoDescCollectionViewCellDelegate> {
    BRChaptersView *_chaptersView;
    CGFloat _height;
}

/// 小说源
@property(nonatomic, strong) NSMutableArray *sitesArray;
@property(nonatomic, assign) NSInteger selectedSiteIndex;
@property(nonatomic, assign) NSInteger currentIndex;


@end

@implementation BRBookInfoCollectionViewController

#pragma mark- Private

- (BRSite *)getTheLastSite {
    BRSite *lastSite = [_sitesArray firstObject];
    for (BRSite *site in _sitesArray) {
        if (lastSite.oid.intValue >= site.oid.intValue) {
            
        } else {
            lastSite = site;
        }
    }
    return lastSite;
}

- (void)createStartButton {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1);
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44 +(isIPhoneXSeries()? 12:0));
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [startBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFFFFF, 1) forState:UIControlStateNormal];
    [startBtn setBackgroundColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1)];
    [startBtn addTarget:self action:@selector(startReadClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(0);
    }];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo((44 +(isIPhoneXSeries()? 12:0))*(-1));
    }];
    [bgView bringSubviewToFront:self.collectionView];
}

- (void)gotoReadWitnIndex:(NSInteger )index {
    BRBookReadViewModel* vm = [[BRBookReadViewModel alloc] initWithBookModel:self.bookInfo];
    vm.sitesArray = _sitesArray;
    vm.currentIndex = index;
    BRBookReadViewController* vc = [[BRBookReadViewController alloc] init];
    vc.viewModel = vm;
    vc.index = index;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showChaptersView {
    [self hideProgressMessage];
    if (!_chaptersView) {
        _chaptersView = [[BRChaptersView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    }

    BRSite *site = nil;

    if (self.bookInfo.siteIndex.integerValue >= 0) {
        site = [_sitesArray objectAtIndex:(self.bookInfo.siteIndex.integerValue >= self.bookInfo.sitesArray.count ? self.bookInfo.sitesArray.count-1 : self.bookInfo.siteIndex.integerValue)];

    } else {
        site = [self getTheLastSite];
        NSInteger siteIndex = [_sitesArray indexOfObject:site];
        self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
    }

    if (site) {
        kWeakSelf(self)
        [self showProgressMessage:@"正在获取最新章节信息..."];
        [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
            kStrongSelf(self)
            [self hideProgressMessage];
            self->_chaptersView.chapters = recodes;
            self->_chaptersView.bookInfo = self.bookInfo;
            [self.view addSubview:self->_chaptersView];
        } failureBlock:^(NSError * _Nonnull error) {
            kStrongSelf(self)
            [self hideProgressMessage];
            [self showErrorMessage:error];
        }];
    }


    kWeakSelf(self);
    _chaptersView.didSelectChapter = ^(NSInteger index) {
        kStrongSelf(self);

        self->_chaptersView.hidden = YES;
        self->_chaptersView.currentIndex = index;
        self.currentIndex = index;
        [self gotoReadWitnIndex:index];
    };
    _chaptersView.didSelectHidden = ^{
        kStrongSelf(self);
        self->_chaptersView.hidden = YES;
    };

    BRBookRecord* model = [[BRDataBaseManager sharedInstance] selectBookRecordWithBookId:self.bookInfo.bookId.stringValue];
    /* 有阅读记录*/
    if (model){
        /* 改变记录值*/
        self.currentIndex = model.chapterIndex;
        _chaptersView.currentIndex = self.currentIndex;
    }

    _chaptersView.bookName = self.bookInfo.bookName;

    self->_chaptersView.hidden = NO;
}

- (void)changeSite{
    BRSitesSelectViewController *vc = [[BRSitesSelectViewController alloc] init];
    vc.bookId = self.bookInfo.bookId;
    vc.sitesArray = _sitesArray;
    vc.selectedSiteIndex = self.bookInfo.siteIndex.integerValue;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addShelf {
    BRBookInfoModel* model = [[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:self.bookInfo.bookId];
    if (model) {
        
    } else {
        [self addBookModel:^{
            
        }];
    }
    [self.collectionView reloadData];
}

/// 按数量缓存 章节
/// @param chapters 所有章节
/// @param count  章节数量 0时 代表所有章节
- (void)cacheChapters:(NSArray<BRChapter *> * _Nonnull)chapters count:(NSInteger)count {
    
    BRBookInfoModel *book = self.bookInfo;
    __weak BRSite *site = [book.sitesArray objectAtIndex:(book.siteIndex.integerValue >= book.sitesArray.count ? book.sitesArray.count -1 : book.siteIndex.integerValue)]; // 这里需要避免 源变更导致的问题
    NSInteger currentIndex = self.viewModel.getCurrentChapterIndex;
    
    NSInteger cacheCount = count;
    if (count <= 0) {
        cacheCount = chapters.count -currentIndex;
    }
    
    if (!chapters || chapters.count == 0) {
        kWeakSelf(self)
        [self addBookModel:^{
            kStrongSelf(self)
           [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
               NSInteger count = chapters.count < cacheCount ? chapters.count : cacheCount;
               NSArray *cacheArray = [chapters subarrayWithRange:NSMakeRange(currentIndex, count)];
               NSMutableArray *cacheChaptersArray = [NSMutableArray array];
               for (BRChapter *chapter in cacheArray) {
                   [cacheChaptersArray addObject:chapter.chapterId];
               }
               [[BRDataBaseCacheManager sharedInstance] cacheChapterContentWithBook:book chapterIds:cacheChaptersArray siteId:site.siteId progress:nil completed:nil];
            }];
        }];
    } else {
       [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
           NSInteger count = chapters.count < cacheCount ? chapters.count : cacheCount;
           NSArray *cacheArray = [chapters subarrayWithRange:NSMakeRange(currentIndex, count)];
           NSMutableArray *cacheChaptersArray = [NSMutableArray array];
           for (BRChapter *chapter in cacheArray) {
               [cacheChaptersArray addObject:chapter.chapterId];
           }
           [[BRDataBaseCacheManager sharedInstance] cacheChapterContentWithBook:book chapterIds:cacheChaptersArray siteId:site.siteId progress:nil completed:nil];
        }];
    }
}

#pragma mark- button methods

- (void)clickChapterButton:(id)sender {
    [self showChaptersView];
}

- (IBAction)startReadClick:(UIButton *)sender {
    if (_sitesArray.count == 0) {
        return;
    } else {
        [self getTheLastSite];
    }
    [self gotoReadWitnIndex:0];
}

#pragma mark- API

- (void)getBookInfoAndSites {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    self.selectedSiteIndex = -1;
    BRBookInfoModel *dataBaseBook = [[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:self.bookInfo.bookId];
    if(dataBaseBook) {
        self.selectedSiteIndex = dataBaseBook.siteIndex.integerValue;
    }
    
   kWeakSelf(self);
    [BRBookInfoModel getbookinfoWithBookId:self.bookInfo.bookId.longValue isSelect:NO sucess:^(BRBookInfoModel * _Nonnull bookInfo) {
        kStrongSelf(self);
        dispatch_group_leave(group);

        self.bookInfo = bookInfo;
        if (dataBaseBook) {
            self.bookInfo.siteIndex = dataBaseBook.siteIndex;
        }
        [self.collectionView reloadData];
        [[BRDataBaseManager sharedInstance] saveHistoryBookInfoWithModel:self.bookInfo];
        
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
    }];
    
    dispatch_group_enter(group);
    
    [BRSite getSiteListWithBookId:self.bookInfo.bookId sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self);
        self->_sitesArray = [recodes mutableCopy];
        if(self.selectedSiteIndex == -1) {
            
            BRSite *site = [self getTheLastSite];
            NSInteger siteIndex = [self->_sitesArray indexOfObject:site];
            self.bookInfo.sitesArray = self->_sitesArray;
            self.selectedSiteIndex = siteIndex;
            self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
            
            [self.collectionView reloadData];
        }
        
        dispatch_group_leave(group);
        
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        kStrongSelf(self)
        self->_bookInfo.sitesArray = self->_sitesArray;
        [self.collectionView reloadData];
    });
}

- (void)removeBookModel {
    [[BRDataBaseManager sharedInstance] deleteBookInfoWithBookId:self.bookInfo.bookId];
}

- (void)addBookModel:(nullable void (^)(void))completed {
    
    [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:self.bookInfo];
    [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.bookInfo.bookId sites:self.bookInfo.sitesArray curSiteIndex:self.bookInfo.siteIndex.integerValue];
    
    /* 添加书本章节缓存*/
    BRSite *site = [self getTheLastSite];
        
    NSInteger siteIndex = [_sitesArray indexOfObject:site];
    self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
    
    if (site) {
        [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
            completed();
        } failureBlock:^(NSError * _Nonnull error) {
             
        }];
    }
}

#pragma mark- super

- (id)init {
    if (self = [super init]) {
        self.enableModule |= BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
        _height = kBRBookInfoDescCollectionViewCellHeight;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    
    [self.collectionView registerClass:[BRBookListCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookListCollectionViewCell"];
    [self.collectionView registerClass:[BRBookInfoActionsCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookInfoActionsCollectionViewCell"];
    [self.collectionView registerClass:[BRBookInfoDescCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookInfoDescCollectionViewCell"];
    [self.collectionView registerClass:[BRBookInfoSitesCollectionViewCell class] forCellWithReuseIdentifier:@"BRBookInfoSitesCollectionViewCell"];
    
    [self createStartButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headTitle = @"书籍详情";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isFirstLoad) {
        [self getBookInfoAndSites];
    }
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 3) {
        BRBookInfoModel *item = [self.bookInfo.otherBooks objectAtIndex:indexPath.row];
        BRBookInfoCollectionViewController *vc = [[BRBookInfoCollectionViewController alloc] init];
        vc.bookInfo = item;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2) {
        [self changeSite];
    }
}


#pragma mark- UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        BRBookInfoActionsCollectionViewCell *bookInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookInfoActionsCollectionViewCell" forIndexPath:indexPath];
        bookInfoCell.bookInfo = self.bookInfo;
        bookInfoCell.delegate = self;
        cell = bookInfoCell;
    } else if(indexPath.section == 1) {
        BRBookInfoDescCollectionViewCell *descCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookInfoDescCollectionViewCell" forIndexPath:indexPath];
        descCell.bookInfo = self.bookInfo;
        descCell.delegate = self;
        cell = descCell;
    } else if(indexPath.section == 2) {
        BRBookInfoSitesCollectionViewCell *sitesCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookInfoSitesCollectionViewCell" forIndexPath:indexPath];
        sitesCell.bookInfo = self.bookInfo;
        cell = sitesCell;
    } else if(indexPath.section == 3) {
        BRBookListCollectionViewCell *booksCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookListCollectionViewCell" forIndexPath:indexPath];
        BRBookInfoModel *book = [self.bookInfo.otherBooks objectAtIndex:indexPath.row];
        booksCell.bookInfo = book;
        cell = booksCell;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 3) {
        return self.bookInfo.otherBooks.count;
    } else {
        return 1;
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if (indexPath.section == 0) {
        size = CGSizeMake(SCREEN_WIDTH, kBRBookInfoActionsCollectionViewCellHeight);
    } else if(indexPath.section == 1) {
        size = CGSizeMake(SCREEN_WIDTH, _height);
    } else if(indexPath.section == 2) {
        size = CGSizeMake(SCREEN_WIDTH, kBRBookInfoSitesCollectionViewCellHeight);
    } else if(indexPath.section == 3) {
        size = CGSizeMake(SCREEN_WIDTH, kBookListCollectionViewCellHeight);
    }
    return size;
}

#pragma mark- BRBookInfoActionsCollectionViewCellDelegate

- (void)bookInfoActionsCollectionViewCellClickOtherBooksBtn:(UIButton *_Nonnull)button {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}
- (void)bookInfoActionsCollectionViewCellClickAddShelfButton:(UIButton *_Nonnull)button {
    BRBookInfoModel* model = [[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:self.bookInfo.bookId];
    if (model) {
        [self removeBookModel];
    } else {
        [self addBookModel:^{
            
        }];
    }
    [self.collectionView reloadData];
}
- (void)bookInfoActionsCollectionViewCellClickChapterButton:(UIButton *_Nonnull)button {
    [self showChaptersView];
}
- (void)bookInfoActionsCollectionViewCellClickDownloadBtn:(UIButton *_Nonnull)button {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"缓存后续章节" preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self)
    BRBookInfoModel *book = self.bookInfo;
    __weak BRSite *site = [book.sitesArray objectAtIndex:(book.siteIndex.integerValue >= book.sitesArray.count ? book.sitesArray.count -1 : book.siteIndex.integerValue)]; // 这里需要避免 源变更导致的问题
    NSInteger currentIndex = self.viewModel.getCurrentChapterIndex;
    [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
        [alert addAction:[UIAlertAction actionWithTitle:@"后50章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cacheChapters:chapters count:50];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"后200章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cacheChapters:chapters count:200];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"全本缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cacheChapters:chapters count:0];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark- BRSitesSelectViewControllerDelegate

- (void)sitesSelectViewController:(NSInteger )index {
    if(self.bookInfo.siteIndex.intValue != index) {
        self.bookInfo.siteIndex = [NSNumber numberWithInteger:index];
        [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.bookInfo.bookId sites:self.bookInfo.sitesArray curSiteIndex:self.bookInfo.siteIndex.intValue];
        [self.collectionView reloadData];
    }
}

- (void)sitesUpdate:(NSArray<BRSite *> *_Nonnull)sitesArray {
    _sitesArray = [sitesArray mutableCopy];
    self.bookInfo.sitesArray = _sitesArray;
    [self.collectionView reloadData];
}

#pragma mark- BRBookInfoDescCollectionViewCellDelegate

- (void)bookInfoDescCollectionViewCellClickDetailButton:(CGFloat )height {
    _height = height;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
}

@end
