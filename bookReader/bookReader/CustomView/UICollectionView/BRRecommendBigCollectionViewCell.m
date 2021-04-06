//
//  BRRecommendBigCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRRecommendBigCollectionViewCell.h"
#import "CFCustomMacros.h"
#import <YYWebImage.h>
#import <Masonry.h>
#import "CFShadowCornerImageView.h"

@interface BRRecommendBigCollectionViewCell (){
    
//    UILabel *_titleLabel;
    
    CFShadowCornerImageView *_coverImgView;
    UILabel *_bookNameLabel;
    UILabel *_chapterNameLabel;
    
    UILabel *_introLabel;
    
    UILabel *_categoryLabel;

}

@end

@implementation BRRecommendBigCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
//        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
//        _titleLabel.text = @"重磅推荐";
//        [self addSubview:_titleLabel];
        
        _coverImgView = [[CFShadowCornerImageView alloc] init];
        _coverImgView.clipsToBounds = YES;
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_coverImgView];
        
        
        UIImageView *leftShadowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_left_shadow"]];
        [_coverImgView addSubview:leftShadowImg];
        [leftShadowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(13);
        }];
    
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        [self addSubview:_bookNameLabel];
        
        _chapterNameLabel = [[UILabel alloc] init];
        _chapterNameLabel.font = [UIFont systemFontOfSize:12];
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_chapterNameLabel];
        
        _introLabel = [[UILabel alloc] init];
       _introLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
       _introLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
       _introLabel.numberOfLines = 2;
       _introLabel.lineBreakMode = NSLineBreakByWordWrapping;
       [self addSubview:_introLabel];

        
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        [self addSubview:_categoryLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(15);
//        make.height.mas_offset(22);
//    }];
    
    [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 100));
//        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.top.mas_equalTo(7.5);
        make.left.mas_equalTo(0);
    }];
    
    [_coverImgView setImageCornerRadius:4];
    [_coverImgView setShadowWithColor: CFUIColorFromRGBAInHex(0x4C5F68, 1) shadowXOffset:3 shadowYOffset:2 shadowRadius:5 shadowOpacity:0.7];
    
    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImgView.mas_top).offset(0);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(15.5);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bookNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(15.5);
        make.right.mas_equalTo(-18.5);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.height.mas_equalTo(28);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(0);
    }];
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [_coverImgView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    
    NSMutableAttributedString *attributedString = nil;
    if (_bookInfo.intro) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:_bookInfo.intro];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:(5 - (_introLabel.font.lineHeight - _introLabel.font.pointSize))*2];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_bookInfo.intro length])];

    }
    _introLabel.attributedText = attributedString;
    
    NSMutableArray *categoryInfos = [NSMutableArray array];
    if (_bookInfo.author) {
        [categoryInfos addObject:_bookInfo.author];
    }
    if (_bookInfo.categoryName) {
        [categoryInfos addObject:_bookInfo.categoryName];
    }
    if (_bookInfo.isOver.boolValue) {
        [categoryInfos addObject:@"完结"];
    } else {
        [categoryInfos addObject:@"连载"];
    }
    
    NSString *show = [categoryInfos componentsJoinedByString:@"·"];
    
    _categoryLabel.text = show;
    
    [self setNeedsDisplay];
}

@end
