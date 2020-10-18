//
//  BRBookShelfLongCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookShelfLongCollectionViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import <Masonry/Masonry.h>
#import "CFCustomMacros.h"
#import "CFDataUtils.h"

@interface BRBookShelfLongCollectionViewCell () {
    UIImageView *_coverImageView;
    UILabel *_bookNameLabel;
    UILabel *_chapterNameLabel;
    UILabel *_readStatusLabel;
    UILabel *_updataTimeLabel;
    
    UIView *_updateFlagView;
}

@end

@implementation BRBookShelfLongCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
        _coverImageView = [[YYAnimatedImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 3.f;
        [self addSubview:_coverImageView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont systemFontOfSize:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [self addSubview:_bookNameLabel];
        
        _updateFlagView = [[UIView alloc] init];
        _updateFlagView.layer.backgroundColor = CFUIColorFromRGBAInHex(0xFFA400, 1).CGColor;
        _updateFlagView.layer.cornerRadius = 2;
        [self addSubview:_updateFlagView];
        [_updateFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(_bookNameLabel.mas_centerY).offset(0);
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
        
        _chapterNameLabel = [[UILabel alloc] init];
        _chapterNameLabel.font = [UIFont systemFontOfSize:12];
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_chapterNameLabel];
        
        _readStatusLabel = [[UILabel alloc] init];
        _readStatusLabel.font = [UIFont systemFontOfSize:12];
        _readStatusLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_readStatusLabel];
        
        _updataTimeLabel = [[UILabel alloc] init];
        _updataTimeLabel.font = [UIFont systemFontOfSize:10];
        _updataTimeLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        _updataTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_updataTimeLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 80));
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImageView.mas_right).offset(15);
        make.height.mas_equalTo(21);
        make.top.mas_equalTo(_coverImageView.mas_top).offset(0);
        make.right.mas_equalTo(-60);
    }];
    
    [_chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImageView.mas_right).offset(15);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-60);
        make.centerY.mas_equalTo(_coverImageView.mas_centerY).offset(0);
    }];
    
    [_readStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImageView.mas_right).offset(15);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(_coverImageView.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_centerX).offset(-5);
    }];
    
    [_updataTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(5);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(_coverImageView.mas_bottom).offset(0);
        make.right.mas_equalTo(-20);
    }];
    
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [_coverImageView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    _chapterNameLabel.text = _bookInfo.lastChapterName;
    _readStatusLabel.text = _bookInfo.chapterIndexStatus;
    _updataTimeLabel.text = [NSString stringWithFormat:@"最后更新:%@", [CFDataUtils createBookUpdateTime:self.bookInfo.lastupdateDate]];
    
    if (_bookInfo.updateFlag.boolValue) {
        _updateFlagView.hidden = NO;
    } else {
        _updateFlagView.hidden = YES;
    }
    
    [self setNeedsDisplay];
}

@end
