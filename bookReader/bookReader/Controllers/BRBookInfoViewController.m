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


@interface BRBookInfoViewController () {
    UIImageView *_corverImg;
    UILabel *_bookNameLabel;
    UILabel *_authorLabel;
    UILabel *_categoryLabel;
    UILabel *_updateTimeLabel;
    
    UILabel *_scoreLabel;
    
    UIView *_infoActionView;
    CFButtonUpDwon *_addShelfBtn;
    
    BRChaptersView *_chaptersView;
}

/// 小说源
@property(nonatomic, strong)NSArray *sitesArray;

@end

@implementation BRBookInfoViewController

#pragma mark-private

- (void)createBookInfoViewIfNeed {
    if (!_corverImg) {
        _corverImg = [UIImageView new];
        _corverImg.backgroundColor = [UIColor redColor];
        [self.view addSubview:_corverImg];
        [_corverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.equalTo(self.headView.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(98, 131));
        }];
    }
    
    if (!_bookNameLabel) {
        _bookNameLabel = [UILabel new];
        _bookNameLabel.font = [UIFont systemFontOfSize:17];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [self.view addSubview:_bookNameLabel];
        [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_corverImg.mas_right).offset(5);
            make.top.equalTo(_corverImg.mas_top).offset(5);
            make.height.offset(25);
            make.right.offset(20);
        }];
    }
    
    if (!_authorLabel) {
        _authorLabel = [UILabel new];
        _authorLabel.font = [UIFont systemFontOfSize:13];
        _authorLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [self.view addSubview:_authorLabel];
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_bookNameLabel.mas_bottom).offset(2);
            make.height.offset(16);
            make.right.offset(20);
        }];
    }
    
    if (!_categoryLabel) {
        _categoryLabel = [UILabel new];
        _categoryLabel.font = [UIFont systemFontOfSize:13];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [self.view addSubview:_categoryLabel];
        [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_authorLabel.mas_bottom).offset(2);
            make.height.offset(16);
            make.right.offset(20);
        }];
    }
    
    if (!_updateTimeLabel) {
        _updateTimeLabel = [UILabel new];
        _updateTimeLabel.font = [UIFont systemFontOfSize:13];
        _updateTimeLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [self.view addSubview:_updateTimeLabel];
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
        [self.view addSubview:_scoreLabel];
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
    
    [self createStartButton];
}

- (void)createStartButton {
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [startBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFFFFF, 1) forState:UIControlStateNormal];
    [startBtn setBackgroundColor:CFUIColorFromRGBAInHex(0x292F3D, 1)];
    [startBtn addTarget:self action:@selector(startReadClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoActionView addSubview:startBtn];
    startBtn.layer.cornerRadius = 8;
    startBtn.clipsToBounds = YES;
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(isIPhoneXSeries()? -30-12 : -30);
    }];
}

- (void)showChaptersView {
    if (!_chaptersView) {
        _chaptersView = [[BRChaptersView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_WIDTH, SCREEN_HEIGHT -CGRectGetMaxY(self.headView.frame))];
        BRSite *site = [_sitesArray firstObject];
           if (site) {
               [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
                   
                   self->_chaptersView.chapters = recodes;
                   
                   [self.view addSubview:self->_chaptersView];
               } failureBlock:^(NSError * _Nonnull error) {
                   
               }];
           }
    }
    kWeakSelf(self);
    _chaptersView.didSelectChapter = ^(NSInteger index) {
        kStrongSelf(self);
        self->_chaptersView.hidden = YES;
        [self gotoReadWitnIndex:index];
    };
    _chaptersView.bookName = self.bookInfo.bookName;
   
    self->_chaptersView.hidden = NO;
}

- (void)removeBookModel {
    [[BRDataBaseManager sharedInstance] deleteBookInfoWithBookId:self.bookInfo.bookId];
}

- (void)addBookModel {
    [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:self.bookInfo];
    
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

#pragma mark- API

- (void)getBookInfo {
    kWeakSelf(self);
    [BRBookInfoModel getbookinfoWithBookId:self.bookInfo.bookId.longValue isSelect:NO sucess:^(BRBookInfoModel * _Nonnull bookInfo) {
        kStrongSelf(self);
        self.bookInfo = bookInfo;
        [self createBookInfoViewIfNeed];
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
    [BRSite getSiteListWithBookId:self.bookInfo.bookId sucess:^(NSArray * _Nonnull recodes) {
           NSLog(@"小说源 ： %@", recodes);
        self->_sitesArray = [recodes mutableCopy];
       } failureBlock:^(NSError * _Nonnull error) {
           
    }];
    
}

#pragma mark- sette


#pragma mark- button methods

- (void)clickChapterButton:(id)sender {
    [self showChaptersView];
}

- (IBAction)startReadClick:(UIButton *)sender {
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

#pragma mark- super

- (id)init {
    if (self = [super init]) {
        self.enableModule |= BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    
    _infoActionView = [[UIView alloc] init];
    _infoActionView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
//    _infoActionView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _infoActionView.layer.cornerRadius = 12;
    [self.view addSubview:_infoActionView];
    [_infoActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(180);
        make.width.offset(SCREEN_WIDTH);
        make.bottom.offset(0);
    }];
    
    [self createBookInfoViewIfNeed];
    [self createActionButtons];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headTitle = @"书籍详情";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBookInfo];
}


@end
