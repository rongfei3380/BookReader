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
    UIView *_updateFlagView;
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
        
        _updateFlagView = [[UIView alloc] init];
        _updateFlagView.layer.backgroundColor = CFUIColorFromRGBAInHex(0xFFA400, 1).CGColor;
        _updateFlagView.layer.cornerRadius = 2;
        [_coverImageView addSubview:_updateFlagView];
        [_updateFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.right.mas_equalTo(-4);
            make.top.mas_equalTo(4);
        }];

        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:9];
        label.text = @"更新";
        label.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [_updateFlagView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 10));
            make.center.mas_equalTo(0);
        }];
        
        _updateFlagView.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
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
    
    if (_bookInfo.updateFlag.boolValue) {
        _updateFlagView.hidden = NO;
    } else {
        _updateFlagView.hidden = YES;
    }
    [self setNeedsDisplay];
}


@end
