//
//  BRBookInfoViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/10.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookInfoViewController.h"
#import "BRBookInfoModel.h"
#import "CFDataUtils.h"
#import "CFButtonUpDwon.h"
#import "BRBookReadViewController.h"
#import "BRSite.h"
#import "BRChaptersView.h"
#import "BRDataBaseManager.h"
#import <YYWebImage/YYWebImage.h>
#import "BRRecommendCollectionViewCell.h"
#import "UIView+Corner.h"
#import "UIImage+ImageEffects.h"
#import "BRSitesSelectViewController.h"


@interface BRBookInfoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, BRSitesSelectViewControllerDelegate>{
    
    UIScrollView *_contentScrollView;
    UIView *_verticalContainerView;
    
    UIButton *startBtn;
    
    UIImageView *_corverImg;
    UIImageView *_bgImg;
    UILabel *_bookNameLabel;
    UILabel *_authorLabel;
    UILabel *_categoryLabel;
    UILabel *_updateTimeLabel;
    
    UILabel *_scoreLabel;
    
    UIView *_infoActionView;
    CFButtonUpDwon *_addShelfBtn;
    UILabel *_descLlabel;
    UICollectionView *_otherBooksCollectionView;
    
    BRChaptersView *_chaptersView;
}

/// 小说源
@property(nonatomic, strong)NSArray *sitesArray;
@property(nonatomic, assign) NSInteger selectedSiteIndex;

@end

@implementation BRBookInfoViewController

#pragma mark-private

- (UIImage *)creatImageEffects:(UIImage *)sourceImg {
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    UIImage *image = [sourceImg applyBlurWithRadius:6 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    return image;
}


- (void)createBookInfoViewIfNeed {
    if (!_corverImg) {
        _corverImg = [UIImageView new];
        _corverImg.clipsToBounds = YES;
        _corverImg.contentMode = UIViewContentModeScaleAspectFill;
        [_verticalContainerView addSubview:_corverImg];
        [_corverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(98, 131));
        }];
    }
    
    [_corverImg yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    kWeakSelf(self)
    [_corverImg yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"] options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        kStrongSelf(self)
        self->_bgImg.image = [self creatImageEffects:image];
    }];
    
    if (!_bookNameLabel) {
        _bookNameLabel = [UILabel new];
        _bookNameLabel.font = [UIFont boldSystemFontOfSize:17];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [_verticalContainerView addSubview:_bookNameLabel];
        [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_corverImg.mas_right).offset(10);
            make.top.equalTo(_corverImg.mas_top).offset(5);
            make.height.offset(25);
            make.right.offset(20);
        }];
    }
    
    if (!_authorLabel) {
        _authorLabel = [UILabel new];
        _authorLabel.font = [UIFont systemFontOfSize:13];
        _authorLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 0.6);
        [_contentScrollView addSubview:_authorLabel];
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_bookNameLabel.mas_bottom).offset(4);
            make.height.offset(16);
            make.right.offset(20);
        }];
    }
    
    if (!_categoryLabel) {
        _categoryLabel = [UILabel new];
        _categoryLabel.font = [UIFont systemFontOfSize:13];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 0.6);
        [_verticalContainerView addSubview:_categoryLabel];
        [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_authorLabel.mas_bottom).offset(4);
            make.height.offset(16);
            make.right.offset(20);
        }];
    }
    
    if (!_updateTimeLabel) {
        _updateTimeLabel = [UILabel new];
        _updateTimeLabel.font = [UIFont systemFontOfSize:13];
        _updateTimeLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 0.6);
        [_verticalContainerView addSubview:_updateTimeLabel];
        [_updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.bottom.equalTo(_corverImg.mas_bottom).offset(2);
            make.height.offset(16);
            make.right.offset(20);
        }];
    }
    
    if (!_scoreLabel) {
        _scoreLabel = [UILabel new];
        _scoreLabel.textColor = CFUIColorFromRGBAInHex(0xF8554F, 1);
        _scoreLabel.font = [UIFont systemFontOfSize:16];
        [_verticalContainerView addSubview:_scoreLabel];
    }
    
    _bookNameLabel.text = self.bookInfo.bookName;
    _categoryLabel.text = self.bookInfo.categoryName;
    _authorLabel.text = self.bookInfo.author;
    _updateTimeLabel.text = [[CFDataUtils createBookUpdateTime:self.bookInfo.lastupdateDate] stringByAppendingString:@"更新"];
}

- (void)createActionButtons {
    _addShelfBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [_addShelfBtn setImage:[UIImage imageNamed:@"btn_detail_joinShelf"] forState:UIControlStateNormal];
    [_addShelfBtn setTitle:@"加入书架" forState:UIControlStateNormal];
    [_addShelfBtn setTitle:@"移除书架" forState:UIControlStateSelected];
    [_addShelfBtn addTarget:self action:@selector(clickAddShelfBtn:) forControlEvents:UIControlEventTouchUpInside];
    _addShelfBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_addShelfBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [_infoActionView addSubview:_addShelfBtn];
    [self changeSddShelfBtnStatus];
    
    CFButtonUpDwon *chapterBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [chapterBtn setImage:[UIImage imageNamed:@"btn_detail_chapter"] forState:UIControlStateNormal];
    [chapterBtn setTitle:@"章节列表" forState:UIControlStateNormal];
    chapterBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [chapterBtn addTarget:self action:@selector(clickChapterButton:) forControlEvents:UIControlEventTouchUpInside];
    [chapterBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [_infoActionView addSubview:chapterBtn];
    
    CFButtonUpDwon *likeBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:[UIImage imageNamed:@"btn_detail_support"] forState:UIControlStateNormal];
    [likeBtn setTitle:@"支持作品" forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [likeBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [_infoActionView addSubview:likeBtn];
    
    CFButtonUpDwon *downloadBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [downloadBtn setImage:[UIImage imageNamed:@"btn_detail_download"] forState:UIControlStateNormal];
    [downloadBtn setTitle:@"批量下载" forState:UIControlStateNormal];
    downloadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [downloadBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [_infoActionView addSubview:downloadBtn];
    
    NSArray *masonryViewArray = @[_addShelfBtn, chapterBtn, likeBtn, downloadBtn];
    
    // 实现masonry水平固定控件宽度方法
    [masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:20 tailSpacing:20];
    
    // 设置array的垂直方向的约束
    [masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.height.mas_equalTo(50);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = CFUIColorFromRGBAInHex(0xeeeeee, 1);
    [_infoActionView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(81);
    }];
}

- (void)createInfoView {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"书籍简介";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    [_infoActionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_addShelfBtn.mas_bottom).offset(35);
        make.height.mas_equalTo(23);
    }];
    
    _descLlabel = [[UILabel alloc] init];
    _descLlabel.textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
    _descLlabel.font = [UIFont systemFontOfSize:14];
    _descLlabel.numberOfLines = 0;
    _descLlabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_infoActionView addSubview:_descLlabel];
    [self showIntroAttributedString];
    [_descLlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(label.mas_bottom).offset(8);
    }];
    
    UIView *lineView = [UIView new];
   lineView.backgroundColor = CFUIColorFromRGBAInHex(0xeeeeee, 1);
   [_infoActionView addSubview:lineView];
   [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.mas_equalTo(0);
       make.height.mas_equalTo(1);
       make.top.mas_equalTo(_descLlabel.mas_bottom).offset(20);
   }];
    
    UILabel *otherBooksLabel = [[UILabel alloc] init];
    otherBooksLabel.text = @"作者也写过";
    otherBooksLabel.font = [UIFont boldSystemFontOfSize:17];
    otherBooksLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    [_infoActionView addSubview:otherBooksLabel];
    [otherBooksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(lineView.mas_bottom).offset(12);
        make.height.mas_equalTo(23);
    }];
    
    UICollectionViewFlowLayout *booksLayout = [[UICollectionViewFlowLayout alloc] init];
    booksLayout.itemSize = CGSizeMake(84, 160);
    booksLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    booksLayout.minimumLineSpacing = 10;
    
    _otherBooksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:booksLayout];
    _otherBooksCollectionView.delegate = self;
    _otherBooksCollectionView.dataSource = self;
    _otherBooksCollectionView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    [_otherBooksCollectionView registerClass:[BRRecommendCollectionViewCell class] forCellWithReuseIdentifier:@"BRRecommendCollectionViewCell"];
    [_infoActionView addSubview:_otherBooksCollectionView];
    [_otherBooksCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(otherBooksLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(160);
        make.bottom.mas_equalTo(_infoActionView.mas_bottom).offset(0);
    }];
    
    [_infoActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_verticalContainerView.mas_bottom).offset(0);
    }];

    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.mas_equalTo(_verticalContainerView.mas_bottom).offset(0);

    }];
    
    // 这里设置圆角才有效果
    [_infoActionView round:12 RectCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}


- (void)createStartButton {
    startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [startBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFFFFF, 1) forState:UIControlStateNormal];
    [startBtn setBackgroundColor:CFUIColorFromRGBAInHex(0x292F3D, 1)];
    [startBtn addTarget:self action:@selector(startReadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    startBtn.layer.cornerRadius = 8;
    startBtn.clipsToBounds = YES;
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(isIPhoneXSeries()? -30-12 : -30);
    }];
}

- (void)createChangeSiteButton {
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"nav_yuan"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(clickChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)showChaptersView {
    if (!_chaptersView) {
        _chaptersView = [[BRChaptersView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_WIDTH, self.view.frame.size.height -CGRectGetMaxY(self.headView.frame))];
        BRSite *site = [_sitesArray firstObject];
           if (site) {
               kWeakSelf(self)
               [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
                   
                   self->_chaptersView.chapters = recodes;
                   
                   [self.view addSubview:self->_chaptersView];
               } failureBlock:^(NSError * _Nonnull error) {
                   kStrongSelf(self)
                   [self showErrorMessage:error];
               }];
           }
    }
    kWeakSelf(self);
    _chaptersView.didSelectChapter = ^(NSInteger index) {
        kStrongSelf(self);
        self->_chaptersView.hidden = YES;
        [self gotoReadWitnIndex:index];
    };
    _chaptersView.didSelectHidden = ^{
        kStrongSelf(self);
        self->_chaptersView.hidden = YES;
    };
    _chaptersView.bookName = self.bookInfo.bookName;
   
    self->_chaptersView.hidden = NO;
}

- (void)removeBookModel {
    [[BRDataBaseManager sharedInstance] deleteBookInfoWithBookId:self.bookInfo.bookId];
}

- (void)addBookModel {
    [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:self.bookInfo];
    
    // 如果有源 则更新源
    if (_sitesArray.count) {
        [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.bookInfo.bookId sites:_sitesArray curSiteIndex:0];
    }
    
    
    /* 添加书本章节缓存*/
//    if ([[BRDataBaseManager sharedInstance] sel:self.model.book_url].count == 0)
//        [self.bookApi chapterListWithBook:self.model Success:nil Fail:nil];
}

- (void)changeSddShelfBtnStatus {
    BRBookInfoModel* model = [[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:self.bookInfo.bookId];
    if (model) {
        _addShelfBtn.selected = YES;
    } else {
        _addShelfBtn.selected = NO;
    }
}

- (void)gotoReadWitnIndex:(NSInteger )index {
    BRBookReadViewModel* vm = [[BRBookReadViewModel alloc] initWithBookModel:self.bookInfo];
    vm.sitesArray = _sitesArray;
    vm.currentIndex = index;
    BRBookReadViewController* vc = [[BRBookReadViewController alloc] init];
    vc.viewModel = vm;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showIntroAttributedString {
    NSMutableAttributedString *attributedString = nil;
    if (_bookInfo.intro) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_bookInfo.intro];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:(5 - (_descLlabel.font.lineHeight - _descLlabel.font.pointSize))];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_bookInfo.intro length])];
    }
    
    _descLlabel.attributedText = attributedString;
}


#pragma mark- API

- (void)getBookInfo {
    
    self.selectedSiteIndex = 0;
    BRBookInfoModel *dataBaseBook = [[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:self.bookInfo.bookId];
    
    kWeakSelf(self);
    [BRBookInfoModel getbookinfoWithBookId:self.bookInfo.bookId.longValue isSelect:NO sucess:^(BRBookInfoModel * _Nonnull bookInfo) {
        kStrongSelf(self);
        self.bookInfo = bookInfo;
        self.bookInfo.siteIndex = dataBaseBook.siteIndex;
        [self createBookInfoViewIfNeed];
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
    }];
}

/// 获取书本的源
- (void)getSites {
    kWeakSelf(self);
    [BRSite getSiteListWithBookId:self.bookInfo.bookId sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self);
        self->_sitesArray = [recodes mutableCopy];
        self->_bookInfo.sitesArray = self->_sitesArray;

        
        [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.bookInfo.bookId sites:self->_sitesArray curSiteIndex:_bookInfo.siteIndex.intValue];
        
       } failureBlock:^(NSError * _Nonnull error) {
           kStrongSelf(self)
           [self showErrorMessage:error];
    }];
}

#pragma mark- sette
- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [self showIntroAttributedString];
    [_otherBooksCollectionView reloadData];
}

#pragma mark- button methods

- (void)clickChapterButton:(id)sender {
    [self showChaptersView];
}

- (IBAction)startReadClick:(UIButton *)sender {
    if (_sitesArray.count == 0) {
        return;
    }
    [self gotoReadWitnIndex:0];
}

- (void)clickAddShelfBtn:(UIButton *) sender {
    BRBookInfoModel* model = [[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:self.bookInfo.bookId];
    if (model) {
        [self removeBookModel];
    } else {
        [self addBookModel];
    }
    [self changeSddShelfBtnStatus];
}

- (void)clickChangeBtn:(id)sender{
    BRSitesSelectViewController *vc = [[BRSitesSelectViewController alloc] init];
    vc.bookId = self.bookInfo.bookId;
    vc.sitesArray = _sitesArray;
    vc.selectedSiteIndex = self.bookInfo.siteIndex.integerValue;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- super

- (id)init {
    if (self = [super init]) {
        self.enableModule |= BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    
    [self createChangeSiteButton];
    [self createStartButton];
    
    _bgImg = [[UIImageView alloc] init];
    _bgImg.backgroundColor = [UIColor grayColor];
    [self.view insertSubview:_bgImg belowSubview:self.headView];
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT/2.f);
    }];
    
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.clipsToBounds = NO;
    [self.view insertSubview:_contentScrollView belowSubview:self.headView];
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(startBtn.mas_top).offset(0);
//        make.bottom.mas_equalTo(0);
    }];
    
    // 设置scrollView的子视图，即过渡视图contentSize，并设置其约束
    _verticalContainerView = [[UIView alloc] init];
    _verticalContainerView.backgroundColor = [UIColor clearColor];
    [_contentScrollView addSubview:_verticalContainerView];
    [_verticalContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(_contentScrollView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(_contentScrollView);
    }];

    
    
    _infoActionView = [[UIView alloc] init];
    _infoActionView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    [_verticalContainerView addSubview:_infoActionView];
    [_infoActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180);
        make.width.offset(SCREEN_WIDTH);
    }];


    
    
    
    [self createBookInfoViewIfNeed];
    [self createActionButtons];
    [self createInfoView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headTitle = @"书籍详情";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isFirstLoad) {
        [self getBookInfo];
        [self getSites];
    }
    
    
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BRBookInfoModel *item = [self.bookInfo.otherBooks objectAtIndex:indexPath.row];
    
    BRBookInfoViewController *vc = [[BRBookInfoViewController alloc] init];
    vc.bookInfo = item;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BRRecommendCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRRecommendCollectionViewCell" forIndexPath:indexPath];
    
    BRBookInfoModel *item = [self.bookInfo.otherBooks objectAtIndex:indexPath.row];
    
    cell.bookInfo = item;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookInfo.otherBooks.count;
}

- (void)sitesSelectViewController:(NSInteger)index {
    self.bookInfo.siteIndex = [NSNumber numberWithInteger:index];
}


@end
