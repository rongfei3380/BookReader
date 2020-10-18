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
#import "CFDataUtils.h"

@interface BRBookMangerTableViewCell () {
    
    UIImageView *_coverImgView;
    UILabel *_bookNameLabel;
    
    UILabel *_chapterNameLabel;
    UILabel *_readStatusLabel;
    
    UIImageView *_selectedImg;
}

@end


@implementation BRBookMangerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.clipsToBounds = YES;
        [self addSubview:_coverImgView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont systemFontOfSize:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [self addSubview:_bookNameLabel];
        
        _chapterNameLabel = [[UILabel alloc] init];
        _chapterNameLabel.font = [UIFont systemFontOfSize:12];
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_chapterNameLabel];
        
        _readStatusLabel = [[UILabel alloc] init];
        _readStatusLabel.font = [UIFont systemFontOfSize:12];
        _readStatusLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_readStatusLabel];
        
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
    
    [_chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImgView.mas_right).offset(15);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-60);
        make.centerY.mas_equalTo(_coverImgView.mas_centerY).offset(0);
    }];
    
    [_readStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImgView.mas_right).offset(15);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_centerX).offset(-5);
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
    
    _chapterNameLabel.text = _bookInfo.lastChapterName;
    _readStatusLabel.text = _bookInfo.chapterIndexStatus;
    
    if (_bookInfo.isSelected.boolValue) {
        _selectedImg.image = [UIImage imageNamed:@"icon_radio_selected"];
    } else {
        _selectedImg.image = [UIImage imageNamed:@"icon_radio_normal"];
    }
    
    [self setNeedsDisplay];
    
}

@end
