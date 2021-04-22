//
//  BRBookInfoCollectionViewController.m
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookInfoCollectionViewController.h"
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
#import "BRChoseCacheView.h"
#import "BRAPIClient.h"

@interface BRBookInfoCollectionViewController ()<BRBookInfoActionsCollectionViewCellDelegate, BRSitesSelectViewControllerDelegate, BRBookInfoDescCollectionViewCellDelegate, BRChoseCacheViewDelegate> {
    BRChaptersView *_chaptersView;
    CGFloat _height;
    
    NSURLSessionDataTask *_bookInfoTask;
    NSURLSessionDataTask *_sitesTask;
    NSURLSessionDataTask *_chaptersListTask;
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
//    UIView *bgView = [[UIView alloc] init];
//    bgView.backgroundColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1);
//    [self.view addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(44 +(isIPhoneXSeries()? 12:0));
//        make.bottom.mas_equalTo(0);
//    }];
    
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [startBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFFFFF, 1) forState:UIControlStateNormal];
    [startBtn setBackgroundColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1)];
    [startBtn addTarget:self action:@selector(startReadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(49);
        make.bottom.mas_equalTo(((isIPhoneXSeries()? 12 +22:22))*(-1));
    }];
    startBtn.layer.cornerRadius = 49/2.f;
    startBtn.clipsToBounds = YES;
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
    [self hideBookProgressMessage];
    if (!_chaptersView) {
        _chaptersView = [[BRChaptersView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    }

    BRSite *site = nil;

    if (self.bookInfo.sitesArray.count >0 && self.bookInfo.siteIndex.integerValue >= 0) {
        site = [_sitesArray objectAtIndex:(self.bookInfo.siteIndex.integerValue >= self.bookInfo.sitesArray.count ? self.bookInfo.sitesArray.count-1 : self.bookInfo.siteIndex.integerValue)];

    } else {
        site = [self getTheLastSite];
        NSInteger siteIndex = [_sitesArray indexOfObject:site];
        self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
    }

    if (site) {
        kWeakSelf(self)
        [self showProgressMessage:@"正在获取最新章节信息..."];
        [_chaptersListTask cancel];
        _chaptersListTask =
        [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
            kStrongSelf(self)
            [self hideBookProgressMessage];
            self->_sitesArray = [recodes mutableCopy];
            self->_chaptersView.chapters = recodes;
            self->_chaptersView.bookInfo = self.bookInfo;
            [self.view addSubview:self->_chaptersView];
        } failureBlock:^(NSError * _Nonnull error) {
            kStrongSelf(self)
            [self hideBookProgressMessage];
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
        kWeakSelf(self)
                  
      [[BRAPIClient sharedInstance] addbookWithBookId:self.bookInfo.bookId sucess:^(id  _Nonnull dataBody) {
          
      } failureBlock:^(NSError * _Nonnull error) {
          
      }];
        
        [self addBookModelSucess:^(NSArray * _Nonnull recodes) {
            
        } failureBlock:^(NSError * _Nonnull error) {
            kStrongSelf(self)
            [self showErrorMessage:error];
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
    
    if(currentIndex +count > chapters.count -1) {
        cacheCount = chapters.count - currentIndex;
    }
    
    
    if (count <= 0) {
        cacheCount = chapters.count -currentIndex;
    }
    
    if (!chapters || chapters.count == 0) {
        kWeakSelf(self)
        [self addBookModelSucess:^(NSArray * _Nonnull recodes) {
            [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
                kStrongSelf(self)
                NSInteger count = chapters.count < cacheCount ? chapters.count : cacheCount;
                if(count > 0) {
                    NSArray *cacheArray = [chapters subarrayWithRange:NSMakeRange(currentIndex, count)];
                    NSMutableArray *cacheChaptersArray = [NSMutableArray array];
                    for (BRChapter *chapter in cacheArray) {
                        [cacheChaptersArray addObject:chapter.chapterId];
                    }
                 
                    [self showProgressMessage:@"正在添加章节缓存"];
                    [[BRDataBaseCacheManager sharedInstance] cacheChapterContentWithBook:book chapterIds:cacheChaptersArray siteId:site.siteId progress:^(NSInteger receivedCount, NSInteger expectedCount, BRCacheTask * _Nullable task) {
                        kdispatch_main_sync_safe(^{
                            [self hideBookProgressMessage];
                            [self hideBookLoading];
                            [BRMessageHUD showSuccessMessage:@"已添加章节缓存" to:self.view];
                        });
                     } completed:^(BRCacheTask * _Nullable task, NSError * _Nullable error, BOOL finished) {
                             if (error) {
                                 [self hideBookProgressMessage];
                                 [self showErrorMessage:error];
                             }
                    }];
                }
             }];
        } failureBlock:^(NSError * _Nonnull error) {
            kStrongSelf(self)
            [self showErrorMessage:error];
        }];
    } else {
       [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
           NSInteger count = chapters.count < cacheCount ? chapters.count : cacheCount;
           NSArray *cacheArray = [chapters subarrayWithRange:NSMakeRange(currentIndex, count)];
           NSMutableArray *cacheChaptersArray = [NSMutableArray array];
           for (BRChapter *chapter in cacheArray) {
               [cacheChaptersArray addObject:chapter.chapterId];
           }
           [self showProgressMessage:@"正在添加章节缓存"];
           [[BRDataBaseCacheManager sharedInstance] cacheChapterContentWithBook:book chapterIds:cacheChaptersArray siteId:site.siteId progress:^(NSInteger receivedCount, NSInteger expectedCount, BRCacheTask * _Nullable task) {
                             
            } completed:^(BRCacheTask * _Nullable task, NSError * _Nullable error, BOOL finished) {
                kdispatch_main_sync_safe(^{
                    if (error ) {
                        [self hideBookProgressMessage];
                        [self showErrorMessage:error];
                    } else {
                        if (!finished) {
                            kdispatch_main_sync_safe(^{
                                [self hideBookProgressMessage];
                                [self hideBookLoading];
                                [BRMessageHUD showSuccessMessage:@"已添加章节缓存" to:self.view];
                            });
                        }
                    }
                });
            }];
            
        }];
    }
}

- (void)showAlertControllerWithChapters:(NSArray<BRChapter *> *)chapters {
    
    
    
    BRChoseCacheView *vc = [[BRChoseCacheView alloc] init];
    vc.delegate = self;
    vc.allChapters  = chapters;
    [vc show];
    return;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"缓存后续章节" preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self)
    [alert addAction:[UIAlertAction actionWithTitle:@"后50章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        kStrongSelf(self)
        [self cacheChapters:chapters count:50];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"后200章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        kStrongSelf(self)
        [self cacheChapters:chapters count:200];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"全本缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        kStrongSelf(self)
        [self cacheChapters:chapters count:0];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    [self showProgressMessage:@"" closable:YES];
   kWeakSelf(self);
    _bookInfoTask =
    [BRBookInfoModel getbookinfoWithBookId:self.bookInfo.bookId.longValue isSelect:NO sucess:^(BRBookInfoModel * _Nonnull bookInfo) {
        kStrongSelf(self);
        dispatch_group_leave(group);

        self.bookInfo = bookInfo;
        if (dataBaseBook) {
            self.bookInfo.siteIndex = dataBaseBook.siteIndex;
        }
//        [self.collectionView reloadData];
        [[BRDataBaseManager sharedInstance] saveHistoryBookInfoWithModel:self.bookInfo];
        
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self hideProgressMessage];
        [self showErrorMessage:error];
    }];
    
    dispatch_group_enter(group);
    
   _sitesTask = [BRSite getSiteListWithBookId:self.bookInfo.bookId sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self);
        self->_sitesArray = [recodes mutableCopy];
        if(self.selectedSiteIndex == -1) {
            BRSite *site = [self getTheLastSite];
            NSInteger siteIndex = [self->_sitesArray indexOfObject:site];
            self.selectedSiteIndex = siteIndex;
            self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
        }
       self.bookInfo.sitesArray = self->_sitesArray;
        
        dispatch_group_leave(group);
        
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self hideProgressMessage];
        [self showErrorMessage:error];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        kStrongSelf(self)
        self->_bookInfo.sitesArray = self->_sitesArray;
        [self.collectionView reloadData];
        [self hideProgressMessage];
    });
}

- (void)removeBookModel {
    [[BRDataBaseManager sharedInstance] deleteBookInfoWithBookId:self.bookInfo.bookId];
}

- (void)addBookModelSucess:(BRObjectSuccessBlock)successBlock
              failureBlock:(BRObjectFailureBlock)failureBlock {
    
    [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:self.bookInfo];
        
    BRSite *site = nil;
    if(self.bookInfo.siteIndex.integerValue == -1) {
        /* 添加书本章节缓存*/
        site = [self getTheLastSite];
            
        NSInteger siteIndex = [_sitesArray indexOfObject:site];
        self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
        [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.bookInfo.bookId sites:self.bookInfo.sitesArray curSiteIndex:self.bookInfo.siteIndex.integerValue];
    } else {
        site = [self.bookInfo.sitesArray objectAtIndex:self.bookInfo.siteIndex.integerValue];
    }
    
    if (site) {
        [_chaptersListTask cancel];
        _chaptersListTask =
        [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
            successBlock(recodes);
        } failureBlock:^(NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }
}

#pragma mark- super

- (id)init {
    if (self = [super init]) {
        self.enableModule |= BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn;
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
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"othersReusableView"];
    
    [self createStartButton];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo((49+ (isIPhoneXSeries()? 12 +22:22))*(-1));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.headTitle = @"书籍详情";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isFirstLoad) {
        [self getBookInfoAndSites];
    }
}

- (void)dealloc {
    [_bookInfoTask cancel];
    [_sitesTask cancel];
    [_chaptersListTask cancel];
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 3) {
        BRBookInfoModel *item = [self.bookInfo.otherBooks objectAtIndex:indexPath.row];
        BRBookInfoCollectionViewController *vc = [[BRBookInfoCollectionViewController alloc] init];
        vc.bookInfo = item;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
//        BRBookInfoDescCollectionViewCell *descCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRBookInfoDescCollectionViewCell" forIndexPath:indexPath];
//        [descCell clickDetailButton];
    }
    else if (indexPath.section == 2) {
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

            //组头高度
-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    } else {
        return CGSizeMake(0, 0);
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"othersReusableView" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"其他作品";
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = CFUIColorFromRGBAInHex(0x161c2c, 1);
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        }
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11);
            make.right.mas_equalTo(-11);
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(0);
        }];
        return header;
        
    } else {
        return nil;
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
        [self addShelf];
    }
    [self.collectionView reloadData];
}
- (void)bookInfoActionsCollectionViewCellClickChapterButton:(UIButton *_Nonnull)button {
    [self showChaptersView];
}
- (void)bookInfoActionsCollectionViewCellClickDownloadBtn:(UIButton *_Nonnull)button {
    if (!self.bookInfo.sitesArray || self.bookInfo.sitesArray.count == 0) {
        [self showErrorStatus:@"书籍源加载失败请稍后重试~"];
        return;
    }
    
    
    kWeakSelf(self)
    BRBookInfoModel *book = self.bookInfo;
    __weak BRSite *site = [book.sitesArray objectAtIndex:(book.siteIndex.integerValue >= book.sitesArray.count ? book.sitesArray.count -1 : book.siteIndex.integerValue)]; // 这里需要避免 源变更导致的问题
    if ([[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:book.bookId]) {
        kWeakSelf(self)
        if (site) {
            [self showProgressMessage:@"正在获取最新章节信息..."];
            [_chaptersListTask cancel];
            _chaptersListTask =
            [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
                kStrongSelf(self)
                [self hideBookProgressMessage];
                [self showAlertControllerWithChapters:recodes];
            } failureBlock:^(NSError * _Nonnull error) {
                kStrongSelf(self)
                [self hideBookProgressMessage];
                [self showErrorMessage:error];
            }];
        }
    } else {
        [self addBookModelSucess:^(NSArray * _Nonnull recodes) {
            kStrongSelf(self)
            [self showAlertControllerWithChapters:recodes];
        } failureBlock:^(NSError * _Nonnull error) {
            kStrongSelf(self)
            [self hideBookProgressMessage];
            [self showErrorMessage:error];
        }];
    }
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

#pragma mark- BRChoseCacheViewDelegate
- (void)choseCacheViewClickCacheButtonWithChapter:(NSArray *)chapters count:(NSInteger)count {
    [self cacheChapters:chapters count:count];
}

@end
