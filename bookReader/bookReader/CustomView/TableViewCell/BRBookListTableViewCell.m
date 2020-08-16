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
    
    UILabel *_categoryLabel;
}

@end

@implementation BRBookListTableViewCell

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
        
        _introLabel = [[UILabel alloc] init];
        _introLabel.font = [UIFont systemFontOfSize:13];
        _introLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        _introLabel.numberOfLines = 2;
        _introLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_introLabel];
        
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.font = [UIFont systemFontOfSize:11];
        _categoryLabel.textColor = CFUIColorFromRGBAInHex(0xA1AAB3, 1);
        [self addSubview:_categoryLabel];
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
    
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bookNameLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.right.mas_equalTo(-40);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coverImgView.mas_right).offset(18);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(0);
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
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_bookInfo.intro];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:(5 - (_introLabel.font.lineHeight - _introLabel.font.pointSize))];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_bookInfo.intro length])];
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
