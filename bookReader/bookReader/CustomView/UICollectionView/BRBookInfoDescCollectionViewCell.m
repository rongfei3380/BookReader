//
//  BRBookInfoDescCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookInfoDescCollectionViewCell.h"
#import "CFCustomMacros.h"
#import <Masonry.h>
#import "CFButtonLeftRight.h"

@interface BRBookInfoDescCollectionViewCell () {
    UILabel *_descLabel;
    CFButtonLeftRight *_detailBtn;
    NSMutableAttributedString *_attributedString;
}

@end

@implementation BRBookInfoDescCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"简介";
        label.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
        label.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(24);
        }];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = CFUIColorFromRGBAInHex(0x7E8294, 1);
        _descLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        
        _descLabel.numberOfLines = 2;
        _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_descLabel];
    
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11);
            make.right.mas_equalTo(-11);
            make.top.mas_equalTo(label.mas_bottom).offset(13);
        }];
        
        _detailBtn = [CFButtonLeftRight buttonWithType:UIButtonTypeCustom];
        [_detailBtn setTitleColor:CFUIColorFromRGBAInHex(0x8F9396, 1) forState:UIControlStateNormal];
        _detailBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size: 14];
        [_detailBtn setTitle:@"全部 " forState:UIControlStateNormal];
        [_detailBtn setImage:[UIImage imageNamed:@"btn_detail_down"] forState:UIControlStateNormal];
        [_detailBtn setTitle:@"收起 " forState:UIControlStateSelected];
        [_detailBtn setImage:[UIImage imageNamed:@"btn_detail_up"] forState:UIControlStateSelected];
        [_detailBtn addTarget:self action:@selector(clickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_descLabel.mas_right).offset(0);
            make.top.mas_equalTo(_descLabel.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(50, 15));
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentview:)];
        [self.contentView addGestureRecognizer:tap];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = CFUIColorFromRGBAInHex(0xF8F6F9, 1);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(7);
            make.bottom.mas_equalTo(0);
        }];
       
    }
    return self;
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    
    
    if (_bookInfo.intro) {
        _attributedString = [[NSMutableAttributedString alloc] initWithString:_bookInfo.intro];
        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:(5 - (_descLabel.font.lineHeight - _descLabel.font.pointSize))];//调整行间距
//        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
////
//        [_attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_bookInfo.intro length])];
        [_attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size: 14] range:NSMakeRange(0, [_bookInfo.intro length])];
        [_attributedString addAttribute:NSForegroundColorAttributeName value:CFUIColorFromRGBAInHex(0x7E8294, 1) range:NSMakeRange(0, [_bookInfo.intro length])];
        
    }
    
    _descLabel.attributedText = _attributedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)clickDetailBtn:(UIButton *)button {
    CGFloat height = kBRBookInfoDescCollectionViewCellHeight;
    _detailBtn.selected = !button.selected;
    if (_detailBtn.selected) {
        _descLabel.numberOfLines = 0;
        
        CGSize attSize = [_attributedString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -11*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingTruncatesLastVisibleLine context:nil].size;
        height = ceilf(attSize.height)  +95;
        
    } else {
        _descLabel.numberOfLines = 2;
    }
    
    [self setNeedsDisplay];
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookInfoDescCollectionViewCellClickDetailButton:)]) {
        [self.delegate bookInfoDescCollectionViewCellClickDetailButton:height];
    }
}

- (void)clickDetailButton {
    [self clickDetailBtn:_detailBtn];
}

- (void)tapContentview:(UITapGestureRecognizer *)tap {
    [self clickDetailBtn:_detailBtn];
}

//- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
//    CGRect cellFrame = layoutAttributes.frame;
//    cellFrame.size.height= size.height;
//    layoutAttributes.frame= cellFrame;
//
//
//
//    return layoutAttributes;
//}

@end
