//
//  BRBookInfoActionsCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookInfoActionsCollectionViewCell.h"
#import "CFCustomMacros.h"
#import "CFButtonUpDwon.h"
#import "CFShadowCornerImageView.h"
#import <Masonry.h>
#import "BRDataBaseManager.h"

@interface BRBookInfoActionsCollectionViewCell () {
    UIImageView *_corverImg;
    UILabel *_bookNameLabel;
    UILabel *_authorLabel;
    UILabel *_categoryLabel;
    UILabel *_statusLabel;
    
    UIButton *_otherBooksBtn;
    
    CFButtonUpDwon *_addShelfBtn;
    CFButtonUpDwon *chapterBtn;
    CFButtonUpDwon *likeBtn;
    CFButtonUpDwon *downloadBtn;
}

@end

@implementation BRBookInfoActionsCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
        
        _corverImg = [UIImageView new];
        _corverImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_corverImg];
        [_corverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(11);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(90, 122));
        }];
//        [_corverImg setImageCornerRadius:4];
//        [_corverImg setShadowWithColor: CFUIColorFromRGBAInHex(0x4C5F68, 1) shadowXOffset:3 shadowYOffset:2 shadowRadius:5 shadowOpacity:0.7];
        
//        UIImageView *leftShadowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_left_shadow"]];
//        [_corverImg addSubview:leftShadowImg];
//        [leftShadowImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(13);
//        }];
        
        
        _bookNameLabel = [UILabel new];
        _bookNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        [self.contentView addSubview:_bookNameLabel];
        [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_corverImg.mas_right).offset(24.5);
            make.top.equalTo(_corverImg.mas_top).offset(6);
            make.height.offset(25);
            make.right.offset(-20);
        }];
        
        
        _authorLabel = [UILabel new];
        _authorLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _authorLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 0.6);
        [self.contentView addSubview:_authorLabel];
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_bookNameLabel.mas_bottom).offset(3);
            make.height.offset(16);
            make.right.offset(-20);
        }];
        
        
        _categoryLabel = [UILabel new];
        _categoryLabel.font = [UIFont systemFontOfSize:12];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xFFFFFF, 1);
        _categoryLabel.backgroundColor = CFUIColorFromRGBAInHex(0xFF8731, 1);
        _categoryLabel.layer.cornerRadius = 10.f;
        _categoryLabel.clipsToBounds = YES;
        [self.contentView addSubview:_categoryLabel];
        [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left).offset(0);
            make.top.equalTo(_authorLabel.mas_bottom).offset(16);
            make.height.offset(20);
        }];
        
        _statusLabel = [UILabel new];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        _statusLabel.backgroundColor = CFUIColorFromRGBAInHex(0x4C8BFF , 1);
        _statusLabel.layer.cornerRadius = 10.f;
        _statusLabel.clipsToBounds = YES;
        [self.contentView addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_categoryLabel.mas_right).offset(13);
            make.centerY.equalTo(_categoryLabel.mas_centerY).offset(0);
            make.height.offset(20);
        }];
        
        _otherBooksBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherBooksBtn setTitleColor: CFUIColorFromRGBAInHex(0x4C8BFF, 1) forState:UIControlStateNormal];
        _otherBooksBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        [_otherBooksBtn setTitle:@"查看作者更多书籍" forState:UIControlStateNormal];
        [_otherBooksBtn addTarget:self action:@selector(clickOtherBooksBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_otherBooksBtn];
        [_otherBooksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_categoryLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(_bookNameLabel.mas_left).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        
        _addShelfBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
        [_addShelfBtn setImage:[UIImage imageNamed:@"btn_detail_joinShelf"] forState:UIControlStateNormal];
        [_addShelfBtn setTitle:@"加入书架" forState:UIControlStateNormal];
        [_addShelfBtn setTitle:@"移除书架" forState:UIControlStateSelected];
        [_addShelfBtn addTarget:self action:@selector(clickAddShelfBtn:) forControlEvents:UIControlEventTouchUpInside];
        _addShelfBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_addShelfBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:_addShelfBtn];
        _addShelfBtn.enabled = NO;
        
        chapterBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
        [chapterBtn setImage:[UIImage imageNamed:@"btn_detail_chapter"] forState:UIControlStateNormal];
        [chapterBtn setTitle:@"章节列表" forState:UIControlStateNormal];
        chapterBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [chapterBtn addTarget:self action:@selector(clickChapterButton:) forControlEvents:UIControlEventTouchUpInside];
        [chapterBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:chapterBtn];
        
        likeBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
        [likeBtn setImage:[UIImage imageNamed:@"btn_detail_support"] forState:UIControlStateNormal];
        [likeBtn setTitle:@"支持作品" forState:UIControlStateNormal];
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [likeBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:likeBtn];
        
        downloadBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
        [downloadBtn setImage:[UIImage imageNamed:@"icon_yuan"] forState:UIControlStateNormal];
        [downloadBtn setTitle:@"批量下载" forState:UIControlStateNormal];
        [downloadBtn addTarget:self action:@selector(clickDownloadBtn:) forControlEvents:UIControlEventTouchUpInside];
        downloadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [downloadBtn setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:downloadBtn];
        
        NSArray *masonryViewArray = @[_addShelfBtn, chapterBtn, likeBtn, downloadBtn];
        
        // 实现masonry水平固定控件宽度方法
        [masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:11 tailSpacing:11];
        
        // 设置array的垂直方向的约束
        [masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_corverImg.mas_bottom).offset(18);
            make.height.mas_equalTo(50);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = CFUIColorFromRGBAInHex(0xF8F6F9, 1);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(7);
            make.bottom.mas_equalTo(0);
        }];
       
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   
}

- (void)changeSddShelfBtnStatus {
    _addShelfBtn.enabled = YES;
    BRBookInfoModel* model = [[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:self.bookInfo.bookId];
    if (model) {
        _addShelfBtn.selected = YES;
    } else {
        _addShelfBtn.selected = NO;
    }
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo{
    _bookInfo = bookInfo;
    [self changeSddShelfBtnStatus];
    
    [_corverImg yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    _categoryLabel.text = [NSString stringWithFormat:@"  %@  ",_bookInfo.categoryName];
    _authorLabel.text = [NSString stringWithFormat:@"%@·著作",_bookInfo.author];
    _statusLabel.text = [NSString stringWithFormat:@"  %@  ", _bookInfo.isOver.boolValue ? @"完结":@"连载"];
}

#pragma mark- Button Methods

- (void)clickOtherBooksBtn:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookInfoActionsCollectionViewCellClickOtherBooksBtn:)]) {
        [self.delegate bookInfoActionsCollectionViewCellClickOtherBooksBtn:button];
    }
}

- (void)clickAddShelfBtn:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookInfoActionsCollectionViewCellClickAddShelfButton:)]) {
        [self.delegate bookInfoActionsCollectionViewCellClickAddShelfButton:button];
    }
}

- (void)clickChapterButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookInfoActionsCollectionViewCellClickChapterButton:)]) {
        [self.delegate bookInfoActionsCollectionViewCellClickChapterButton:button];
    }
}

- (void)clickDownloadBtn:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookInfoActionsCollectionViewCellClickDownloadBtn:)]) {
        [self.delegate bookInfoActionsCollectionViewCellClickDownloadBtn:button];
    }
}

@end
