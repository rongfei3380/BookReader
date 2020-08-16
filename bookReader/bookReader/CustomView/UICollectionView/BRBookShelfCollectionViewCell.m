//
//  BRBookShelfCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookShelfCollectionViewCell.h"
#import "CFCustomMacros.h"
#import <YYWebImage.h>
#import <Masonry.h>


@interface  BRBookShelfCollectionViewCell () {
    UIImageView *_coverImageView;
    UILabel *_bookNameLabel;
    UILabel *_readStatusLabel;
}

@end

@implementation BRBookShelfCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
        _coverImageView = [[YYAnimatedImageView alloc] init];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.cornerRadius = 3.f;
        [self addSubview:_coverImageView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont systemFontOfSize:13];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [self addSubview:_bookNameLabel];
        
        _readStatusLabel = [[UILabel alloc] init];
        _readStatusLabel.font = [UIFont systemFontOfSize:11];
        _readStatusLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_readStatusLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-25);
    }];

    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImageView.mas_bottom).offset(4);
        make.left.right.mas_equalTo(0);
        
    }];
    [_readStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bookNameLabel.mas_bottom).offset(3);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [_coverImageView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    _readStatusLabel.text = _bookInfo.chapterIndexStatus;
    [self setNeedsDisplay];
}


@end
