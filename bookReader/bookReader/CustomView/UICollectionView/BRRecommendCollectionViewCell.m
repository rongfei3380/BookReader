//
//  BRRecommendCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRRecommendCollectionViewCell.h"
#import "CFCustomMacros.h"
#import <YYWebImage.h>
#import <Masonry.h>
#import "CFShadowCornerImageView.h"

@interface BRRecommendCollectionViewCell (){
    CFShadowCornerImageView *_coverImageView;
    UILabel *_bookNameLabel;
    UILabel *_authorLabel;
}

@end


/// 推荐位 小
@implementation BRRecommendCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
        _coverImageView = [[CFShadowCornerImageView alloc] init];
        
        UIImageView *leftShadowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_left_shadow"]];
        [_coverImageView addSubview:leftShadowImg];
        [leftShadowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(13);
        }];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_coverImageView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.numberOfLines = 2;
        _bookNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        [self addSubview:_bookNameLabel];
        
        
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.numberOfLines = 2;
        _authorLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _authorLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        [self addSubview:_authorLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-46);
    }];
    
    
    [_coverImageView setImageCornerRadius:4];
    [_coverImageView setShadowWithColor: CFUIColorFromRGBAInHex(0x4C5F68, 1) shadowXOffset:3 shadowYOffset:2 shadowRadius:5 shadowOpacity:0.7];

    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImageView.mas_bottom).offset(6);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bookNameLabel.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [_coverImageView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    _authorLabel.text = _bookInfo.author;
    [self setNeedsDisplay];
}

@end
