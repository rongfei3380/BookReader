//
//  BRBookMangerTableViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookMangerTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import <Masonry/Masonry.h>
#import "CFCustomMacros.h"

@interface BRBookMangerTableViewCell () {
    
    UIImageView *_coverImgView;
    UILabel *_bookNameLabel;
    
    UILabel *_categoryLabel;
    
    UIImageView *_selectedImg;
}

@end


@implementation BRBookMangerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.clipsToBounds = YES;
        [self addSubview:_coverImgView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont systemFontOfSize:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [self addSubview:_bookNameLabel];
        
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.layer.borderWidth = 0.5;
        _categoryLabel.layer.cornerRadius = 1.f;
        _categoryLabel.font = [UIFont systemFontOfSize:9];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        _categoryLabel.layer.borderColor = CFUIColorFromRGBAInHex(0xDDDDDD, 1).CGColor;
        [self addSubview:_categoryLabel];
        
        _selectedImg = [UIImageView new];
        [self addSubview:_selectedImg];
        
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 86));
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
    }];
    
    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImgView.mas_top).offset(0);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(0);
    }];

    [_selectedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20, 20));
        make.right.mas_offset(-20);
        make.centerY.mas_offset(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    
    [_coverImgView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _bookInfo.bookName;
    
    _categoryLabel.text = [NSString stringWithFormat:@"  %@  ", _bookInfo.categoryName];
    
    if (_bookInfo.isSelected.boolValue) {
        _selectedImg.image = [UIImage imageNamed:@"icon_radio_selected"];
    } else {
        _selectedImg.image = [UIImage imageNamed:@"icon_radio_normal"];
    }
    
    [self setNeedsDisplay];
    
}

@end