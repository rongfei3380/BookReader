//
//  BRBookListTableViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookListTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import <Masonry/Masonry.h>
#import "CFCustomMacros.h"

@interface BRBookListTableViewCell () {
    
    UIImageView *_coverImgView;
    UILabel *_bookNameLabel;
    UILabel *_introLabel;
    UILabel *_authorLabel;
    
    UILabel *_categoryLabel;
    UILabel *_overFlageLabel;
}

@end

@implementation BRBookListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.clipsToBounds = YES;
        _coverImgView.layer.cornerRadius = 3.f;
        [self addSubview:_coverImgView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x333333, 1);
        [self addSubview:_bookNameLabel];
        
        _introLabel = [[UILabel alloc] init];
        _introLabel.font = [UIFont systemFontOfSize:13];
        _introLabel.textColor = CFUIColorFromRGBAInHex(0x333333, 1);
        _introLabel.numberOfLines = 2;
        _introLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_introLabel];
        
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:10];
        _authorLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        [self addSubview:_authorLabel];
        
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.font = [UIFont systemFontOfSize:10];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xFF8731, 1);
        _categoryLabel.layer.borderColor = CFUIColorFromRGBAInHex(0xFF8731, 1).CGColor;
        _categoryLabel.layer.borderWidth = 0.5f;
        _categoryLabel.clipsToBounds = YES;
        _categoryLabel.layer.cornerRadius = 8.f;
        _categoryLabel.backgroundColor = CFUIColorFromRGBAInHex(0xFFF4E9, 1);
        [self addSubview:_categoryLabel];
        
        _overFlageLabel = [[UILabel alloc] init];
        _overFlageLabel.font = [UIFont systemFontOfSize:10];
        _overFlageLabel.textColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1);
        _overFlageLabel.layer.borderWidth = 0.5f;
        _overFlageLabel.layer.borderColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1).CGColor;
        _overFlageLabel.clipsToBounds = YES;
        _overFlageLabel.layer.cornerRadius = 8.f;
        _overFlageLabel.backgroundColor = CFUIColorFromRGBAInHex(0xE7EFFF, 1);
        [self addSubview:_overFlageLabel];
        
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
        make.size.mas_equalTo(CGSizeMake(76, 100));
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImgView.mas_top).offset(2);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(16);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(20);
    }];
    
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bookNameLabel.mas_bottom).offset(11);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.right.mas_equalTo(-24);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.height.mas_equalTo(15);
//        make.top.mas_equalTo(_introLabel.mas_bottom).offset(11);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(-2);
    }];
    
    [_overFlageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(-1);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_overFlageLabel.mas_left).offset(-18);
        make.height.mas_equalTo(16);
//        make.top.mas_equalTo(_introLabel.mas_bottom).offset(11);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(-1);
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
    _authorLabel.text = _bookInfo.author;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_bookInfo.intro];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:(5 - (_introLabel.font.lineHeight - _introLabel.font.pointSize))];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_bookInfo.intro length])];
    _introLabel.attributedText = attributedString;

    
    if (_bookInfo.isOver.boolValue) {
        _overFlageLabel.text = @"  完结  ";
    } else {
        _overFlageLabel.text = @"  连载  ";
    }
    
    _categoryLabel.text = [NSString stringWithFormat:@"  %@  ", _bookInfo.categoryName];
    
    [self setNeedsDisplay];
    
}

@end
