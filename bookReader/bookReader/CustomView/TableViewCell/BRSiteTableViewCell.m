//
//  BRSiteTableViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/30.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSiteTableViewCell.h"
#import "CFCustomMacros.h"
#import <Masonry/Masonry.h>

@interface BRSiteTableViewCell () {
    UILabel *_siteNameLabel;
    UILabel *_lastChapterNameLabel;
    
    UIImageView *_selectedImg;
}

@end


@implementation BRSiteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _siteNameLabel = [[UILabel alloc] init];
        _siteNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        _siteNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_siteNameLabel];
        
        _lastChapterNameLabel = [[UILabel alloc] init];
        _lastChapterNameLabel.textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
        _lastChapterNameLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_lastChapterNameLabel];
        
        _selectedImg = [UIImageView new];
        [self addSubview:_selectedImg];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = CFUIColorFromRGBAInHex(0xEEEEEE, 1);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.height.mas_equalTo(0.5);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_siteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(13);
        make.height.mas_equalTo(18);
    }];
    
    [_lastChapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(15);
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

- (void)setSite:(BRSite *)site {
    _site = site;
    _siteNameLabel.text = _site.siteName;
    _lastChapterNameLabel.text = _site.lastChapterName;
    
//    if (_bookInfo.isSelected.boolValue) {
           _selectedImg.image = [UIImage imageNamed:@"icon_radio_selected"];
//    } else {
//           _selectedImg.image = [UIImage imageNamed:@"icon_radio_normal"];
//    }
//    
    [self setNeedsDisplay];
}

@end
