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
}

@end

@implementation BRBookShelfCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverImageView = [[YYAnimatedImageView alloc] init];
        [self addSubview:_coverImageView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont systemFontOfSize:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [self addSubview:_bookNameLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-32);
    }];

    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImageView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [_coverImageView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    
    [self setNeedsDisplay];
}


@end
