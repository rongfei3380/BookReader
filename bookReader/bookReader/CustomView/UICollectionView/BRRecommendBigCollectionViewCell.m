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

@interface BRRecommendBigCollectionViewCell (){
    
    UILabel *_titleLabel;
    
    UIImageView *_coverImgView;
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
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"主编推荐";
        [self addSubview:_titleLabel];
        
        _coverImgView = [[YYAnimatedImageView alloc] init];
        [self addSubview:_coverImgView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont systemFontOfSize:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [self addSubview:_bookNameLabel];
        
        _chapterNameLabel = [[UILabel alloc] init];
        _chapterNameLabel.font = [UIFont systemFontOfSize:12];
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_chapterNameLabel];
        
        _introLabel = [[UILabel alloc] init];
       _introLabel.font = [UIFont systemFontOfSize:12];
       _introLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
       _introLabel.numberOfLines = 3;
       _introLabel.lineBreakMode = NSLineBreakByWordWrapping;
       [self addSubview:_introLabel];

        
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.layer.borderWidth = 0.5;
        _categoryLabel.layer.cornerRadius = 1.f;
        _categoryLabel.font = [UIFont systemFontOfSize:9];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        _categoryLabel.layer.borderColor = CFUIColorFromRGBAInHex(0xDDDDDD, 1).CGColor;
        [self addSubview:_categoryLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_offset(22);
    }];
    
    [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(96, 130));
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(0);
    }];
    
    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImgView.mas_top).offset(0);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bookNameLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(0);
    }];
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [_coverImgView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    _introLabel.text = _bookInfo.intro;
    _categoryLabel.text = _bookInfo.categoryName;
    
    [self setNeedsDisplay];
}

@end