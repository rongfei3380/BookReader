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
#import "DBGHTMLEntityDecoder.h"
#import "CFStrokeLabel.h"
#import "CFButtonLeftRight.h"
#import "CFShadowCornerImageView.h"

@interface BRBookInfoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, BRSitesSelectViewControllerDelegate>{
    
    UIScrollView *_contentScrollView;
    UIView *_verticalContainerView;
    
    UIButton *startBtn;
    
    CFShadowCornerImageView *_corverImg;
//    UIImageView *_bgImg;
    UILabel *_bookNameLabel;
    UILabel *_authorLabel;
    UILabel *_categoryLabel;
    UILabel *_statusLabel;
    
    
    UILabel *_scoreLabel;
    
    UIView *_infoActionView;
    CFButtonUpDwon *_addShelfBtn;
    UILabel *label;
    UILabel *_descLabel;
    CFButtonLeftRight *_detailBtn;
    UIView *_desclineView;

    UIView *_sourcSiteView; // 源的背景view
    UILabel *_siteLabel;
    UILabel *_lastChapterLabel;
    UILabel *_updateTimeLabel;
    
    UILabel *otherBooksLabel;
    UICollectionView *_otherBooksCollectionView;
    
    BRChaptersView *_chaptersView;
}

/// 小说源
@property(nonatomic, strong) NSMutableArray *sitesArray;
@property(nonatomic, assign) NSInteger selectedSiteIndex;
@property(nonatomic, assign) NSInteger currentIndex;

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
        _corverImg = [CFShadowCornerImageView new];
        _corverImg.contentMode = UIViewContentModeScaleAspectFill;
        [_verticalContainerView addSubview:_corverImg];
        [_corverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(11);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(90, 122));
        }];
        [_corverImg setImageCornerRadius:4];
        [_corverImg setShadowWithColor: CFUIColorFromRGBAInHex(0x4C5F68, 1) shadowXOffset:3 shadowYOffset:2 shadowRadius:5 shadowOpacity:0.7];
        
        UIImageView *leftShadowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_left_shadow"]];
        [_corverImg addSubview:leftShadowImg];
        [leftShadowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(13);
        }];
        
    }
    
    [_corverImg yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    
    if (!_bookNameLabel) {
        _bookNameLabel = [UILabel new];
        _bookNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        [_verticalContainerView addSubview:_bookNameLabel];
        [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_corverImg.mas_right).offset(24.5);
            make.top.equalTo(_corverImg.mas_top).offset(6);
            make.height.offset(25);
            make.right.offset(-20);
        }];
    }
    
    if (!_authorLabel) {
        _authorLabel = [UILabel new];
        _authorLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _authorLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 0.6);
        [_contentScrollView addSubview:_authorLabel];
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_bookNameLabel.mas_bottom).offset(3);
            make.height.offset(16);
            make.right.offset(-20);
        }];
    }
    
    if (!_categoryLabel) {
        _categoryLabel = [UILabel new];
        _categoryLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xFFFFFF, 1);
        _categoryLabel.backgroundColor = CFUIColorFromRGBAInHex(0xFF8731, 1);
        _categoryLabel.layer.cornerRadius = 10.f;
        _categoryLabel.clipsToBounds = YES;
        [_verticalContainerView addSubview:_categoryLabel];
        [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_authorLabel.mas_bottom).offset(16);
            make.height.offset(20);
        }];
    }
    
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _statusLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        _statusLabel.backgroundColor = CFUIColorFromRGBAInHex(0x4C8BFF , 1);
        _statusLabel.layer.cornerRadius = 10.f;
        _statusLabel.clipsToBounds = YES;
        [_verticalContainerView addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_categoryLabel.mas_right).offset(13);
            make.centerY.equalTo(_categoryLabel.mas_centerY).offset(0);
            make.height.offset(20);
        }];
    }
    
    if (!_scoreLabel) {
        _scoreLabel = [UILabel new];
        _scoreLabel.textColor = CFUIColorFromRGBAInHex(0xF8554F, 1);
        _scoreLabel.font = [UIFont systemFontOfSize:16];
        [_verticalContainerView addSubview:_scoreLabel];
    }
    
    _bookNameLabel.text = self.bookInfo.bookName;
    _categoryLabel.text = [NSString stringWithFormat:@"  %@  ",self.bookInfo.categoryName];
    _authorLabel.text = [NSString stringWithFormat:@"%@·著作",self.bookInfo.author];
    _statusLabel.text = [NSString stringWithFormat:@"  %@  ", self.bookInfo.isOver.boolValue ? @"完结":@"连载"];
    
    
    
    // 这个方法有点迷幻~
//    [_infoActionView round:12 RectCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
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
    _addShelfBtn.enabled = NO;
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
    [downloadBtn setImage:[UIImage imageNamed:@"icon_yuan"] forState:UIControlStateNormal];
    [downloadBtn setTitle:@"更换源" forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(clickChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    downloadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [downloadBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [_infoActionView addSubview:downloadBtn];
    
    NSArray *masonryViewArray = @[_addShelfBtn, chapterBtn, likeBtn, downloadBtn];
    
    // 实现masonry水平固定控件宽度方法
    [masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:20 tailSpacing:20];
    
    // 设置array的垂直方向的约束
    [masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.height.mas_equalTo(50);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = CFUIColorFromRGBAInHex(0xF8F6F9, 1);
    [_infoActionView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(7);
        make.top.mas_equalTo(70);
    }];
}

- (void)createSourcSiteView {
    _sourcSiteView = [UIView new];
    [_infoActionView addSubview:_sourcSiteView];
    [_sourcSiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(_desclineView.mas_bottom).offset(0);
        make.height.mas_equalTo(99);
    }];
    
    _siteLabel = [UILabel new];
    _siteLabel.font = [UIFont systemFontOfSize:14];
    _siteLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
    [_sourcSiteView addSubview:_siteLabel];
    [_siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.height.mas_equalTo(20);
    }];
    
    _lastChapterLabel = [UILabel new];
    _lastChapterLabel.font = [UIFont systemFontOfSize:16];
    _lastChapterLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
    [_sourcSiteView addSubview:_lastChapterLabel];
    [_lastChapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_siteLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.height.mas_equalTo(20);
    }];

    
    if (!_updateTimeLabel) {
        _updateTimeLabel = [UILabel new];
        _updateTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _updateTimeLabel.numberOfLines = 0;
        _updateTimeLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        [_verticalContainerView addSubview:_updateTimeLabel];
        [_updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11);
            make.top.equalTo(_lastChapterLabel.mas_bottom).offset(5);
            make.height.offset(20);
            make.right.offset(-11);
        }];
    }
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = CFUIColorFromRGBAInHex(0xF8F6F9, 1);
    [_infoActionView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(7);
        make.top.mas_equalTo(_sourcSiteView.mas_bottom).offset(0);
    }];
}

- (void)createInfoView {
    
    label = [[UILabel alloc] init];
    label.text = @"简介";
    label.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    label.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
    [_infoActionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_addShelfBtn.mas_bottom).offset(45);
        make.height.mas_equalTo(24);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.numberOfLines = 4;
    _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_infoActionView addSubview:_descLabel];
    [self showIntroAttributedString];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(label.mas_bottom).offset(13);
    }];
    
    _detailBtn = [CFButtonLeftRight buttonWithType:UIButtonTypeCustom];
    [_detailBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_detailBtn setTitle:@"全部 " forState:UIControlStateNormal];
    [_detailBtn setImage:[UIImage imageNamed:@"btn_detail_down"] forState:UIControlStateNormal];
    [_detailBtn setTitle:@"收起 " forState:UIControlStateSelected];
    [_detailBtn setImage:[UIImage imageNamed:@"btn_detail_up"] forState:UIControlStateSelected];
    [_detailBtn addTarget:self action:@selector(clickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    _detailBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_infoActionView addSubview:_detailBtn];
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_descLabel.mas_left).offset(0);
        make.top.mas_equalTo(_descLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    
    _desclineView = [UIView new];
    _desclineView.backgroundColor = CFUIColorFromRGBAInHex(0xF8F6F9, 1);
    [_infoActionView addSubview:_desclineView];
    [_desclineView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.mas_equalTo(0);
       make.height.mas_equalTo(7);
       make.top.mas_equalTo(_detailBtn.mas_bottom).offset(10);
    }];
    
    [self createSourcSiteView];
    
    otherBooksLabel = [[UILabel alloc] init];
    otherBooksLabel.text = @"作者也写过";
    otherBooksLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
    otherBooksLabel.textColor = CFUIColorFromRGBAInHex(0x2A303E, 1);
    [_infoActionView addSubview:otherBooksLabel];
    [otherBooksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_sourcSiteView.mas_bottom).offset(20);
        make.height.mas_equalTo(23);
    }];
    
    UICollectionViewFlowLayout *booksLayout = [[UICollectionViewFlowLayout alloc] init];
    booksLayout.itemSize = CGSizeMake(84, 160);
    booksLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
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
        make.top.mas_equalTo(otherBooksLabel.mas_bottom).offset(24);
        make.height.mas_equalTo(160);
        make.bottom.mas_equalTo(_infoActionView.mas_bottom).offset(0);
    }];
    
    [_infoActionView setNeedsDisplay];
    
    [_infoActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_verticalContainerView.mas_bottom).offset(0);
    }];

    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_verticalContainerView.mas_bottom).offset(0);
    }];
    
    // 这里设置圆角才有效果
//    [_infoActionView round:12 RectCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}


- (void)createStartButton {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44 +(isIPhoneXSeries()? 42:30));
        make.bottom.mas_equalTo(0);
    }];
    
    
    startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [startBtn setTitleColor:CFUIColorFromRGBAInHex(0xFFFFFF, 1) forState:UIControlStateNormal];
    [startBtn setBackgroundColor:CFUIColorFromRGBAInHex(0x292F3D, 1)];
    [startBtn addTarget:self action:@selector(startReadClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:startBtn];
    startBtn.layer.cornerRadius = 8;
    startBtn.clipsToBounds = YES;
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(0);
    }];
}

//- (void)createChangeSiteButton {
//    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [changeBtn setImage:[UIImage imageNamed:@"nav_yuan"] forState:UIControlStateNormal];
//    [changeBtn addTarget:self action:@selector(clickChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headView addSubview:changeBtn];
//    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-5);
//        make.centerY.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
//}

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

- (void)removeBookModel {
    [[BRDataBaseManager sharedInstance] deleteBookInfoWithBookId:self.bookInfo.bookId];
}

- (void)addBookModel {
    
    [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:self.bookInfo];
    [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.bookInfo.bookId sites:self.bookInfo.sitesArray curSiteIndex:self.bookInfo.siteIndex.integerValue];
    
    /* 添加书本章节缓存*/
    BRSite *site = [self getTheLastSite];
    
    NSInteger siteIndex = [_sitesArray indexOfObject:site];
    self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
    
    if (site) {
        [BRChapter getChaptersListWithBookId:self.bookInfo.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
              
        } failureBlock:^(NSError * _Nonnull error) {
             
        }];
    }
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
    vc.index = index;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showIntroAttributedString {
    NSMutableAttributedString *attributedString = nil;
    if (_bookInfo.intro) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:_bookInfo.intro];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:(5 - (_descLabel.font.lineHeight - _descLabel.font.pointSize))];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_bookInfo.intro length])];
    }
    
    _descLabel.attributedText = attributedString;
}

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
        
        [self createBookInfoViewIfNeed];
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
            [self getTheLastSite];
            BRSite *site = [self getTheLastSite];
            NSInteger siteIndex = [self->_sitesArray indexOfObject:site];
            self.selectedSiteIndex = siteIndex;
            self.bookInfo.siteIndex = [NSNumber numberWithInteger:siteIndex];
            [self updateSoureSite];
        }
        
        dispatch_group_leave(group);
        
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        [self showErrorMessage:error];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        kStrongSelf(self)
        self->_bookInfo.sitesArray = self->_sitesArray;
        self->_addShelfBtn.enabled = YES;
    });

    
}

- (void)updateSoureSite {
    BRSite *site = [self getTheLastSite];
    NSString *updateTime = [[CFDataUtils createBookUpdateTime:site.lastupdateDate] stringByAppendingString:@"更新"];
//    if (self.bookInfo.lastupdateDate && lastChapter) {
//        NSString *showStr = [NSString stringWithFormat:@"%@", lastChapter];
//
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:showStr];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//        [paragraphStyle setLineSpacing:(6 - (_updateTimeLabel.font.lineHeight - _updateTimeLabel.font.pointSize))];//调整行间距
//        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [showStr length])];
//
//        _updateTimeLabel.attributedText =  attributedString;
//    }

    _updateTimeLabel.text = updateTime;
    
    self.bookInfo.sitesArray = _sitesArray;
    _lastChapterLabel.text = site.lastChapterName;
    _siteLabel.text = [NSString stringWithFormat:@"共有%ld个书源，当前源：%@", self.bookInfo.sitesArray.count, site.siteName];
    
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
    } else {
        [self getTheLastSite];
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

- (void)clickDetailBtn:(UIButton *)button {
    _detailBtn.selected = !button.selected;
    if (_detailBtn.selected) {
        _descLabel.numberOfLines = 0;
    } else {
        _descLabel.numberOfLines = 4;
    }
    // 这里重新设置圆角 才会改变尺寸
//    [_infoActionView round:12 RectCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
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
    
//    [self createChangeSiteButton];
    [self createStartButton];
    
//    _bgImg = [[UIImageView alloc] init];
////    _bgImg.backgroundColor = [UIColor grayColor];
//    [self.view insertSubview:_bgImg belowSubview:self.headView];
//    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(SCREEN_HEIGHT/2.f);
//    }];
//
//
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT/2.f);
//    gl.startPoint = CGPointMake(0, 0);
//    gl.endPoint = CGPointMake(1, 1);
//    gl.colors = @[(__bridge id)CFUIColorFromRGBAInHex(0xD0DFEF, 1).CGColor,(__bridge id)CFUIColorFromRGBAInHex(0xF1F8FF, 1).CGColor];
//    gl.locations = @[@(0.0),@(1.0f)];
//
//    [_bgImg.layer addSublayer:gl];

    
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.clipsToBounds = NO;
    [self.view insertSubview:_contentScrollView belowSubview:self.headView];
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(startBtn.mas_top).offset(0);
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
        make.top.mas_equalTo(152);
        make.left.bottom.and.right.equalTo(_verticalContainerView).with.insets(UIEdgeInsetsZero);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.headTitle = @"书籍详情";
    [self createBookInfoViewIfNeed];
    [self createActionButtons];
    [self createInfoView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.isFirstLoad) {
        [self getBookInfoAndSites];
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
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 3) {
        return 1;
    } else {
        return self.bookInfo.otherBooks.count;
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(96, 130+32);
}



- (void)sitesSelectViewController:(NSInteger)index {
    if(self.bookInfo.siteIndex.intValue != index) {
        self.bookInfo.siteIndex = [NSNumber numberWithInteger:index];
        [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.bookInfo.bookId sites:self.bookInfo.sitesArray curSiteIndex:self.bookInfo.siteIndex.intValue];
    }
    
}




@end
