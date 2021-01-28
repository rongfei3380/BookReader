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
#import "CFDataUtils.h"

@interface BRSiteTableViewCell () {
    UILabel *_siteNameLabel;
    
    UILabel *_lastChapterTimeLabel;
    UILabel *_lastChapterNameLabel;
    
    UIImageView *_selectedImg;
}

@end


@implementation BRSiteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xF5F5F5, 1);
        self.contentView.backgroundColor = CFUIColorFromRGBAInHex(0xF5F5F5, 1);
        
        UIView *cardView = [UIView new];
        cardView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [self.contentView addSubview:cardView];
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(0);
        }];
      
        cardView.layer.shadowColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.3].CGColor;
        cardView.layer.shadowOffset = CGSizeMake(0,2);
        cardView.layer.shadowOpacity = 1;
        cardView.layer.shadowRadius = 5;
        cardView.layer.cornerRadius = 4;

        
        _siteNameLabel = [[UILabel alloc] init];
        _siteNameLabel.textColor = CFUIColorFromRGBAInHex(0x000000, 1);
        _siteNameLabel.font = [UIFont systemFontOfSize:16];
        [cardView addSubview:_siteNameLabel];
        
        _lastChapterNameLabel = [[UILabel alloc] init];
        _lastChapterNameLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        _lastChapterNameLabel.font = [UIFont systemFontOfSize:13];
        [cardView addSubview:_lastChapterNameLabel];
        
        _lastChapterTimeLabel = [[UILabel alloc] init];
        _lastChapterTimeLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        _lastChapterTimeLabel.font = [UIFont systemFontOfSize:11];
        [cardView addSubview:_lastChapterTimeLabel];
        
        _selectedImg = [UIImageView new];
        [cardView addSubview:_selectedImg];
        
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
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(18);
    }];
    
    [_lastChapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(_siteNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(15);

    }];
    
    [_lastChapterTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_lastChapterNameLabel.mas_left).offset(0);
        make.top.mas_equalTo(_lastChapterNameLabel.mas_bottom).offset(12);
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
    
    _lastChapterTimeLabel.text = [NSString stringWithFormat:@"%@更新",[CFDataUtils createBookUpdateTime:_site.lastupdateDate]];
    
    _lastChapterNameLabel.text = _site.lastChapterName;

    
    
    if (_site.isSelected.boolValue) {
           _selectedImg.image = [UIImage imageNamed:@"icon_radio_selected"];
    } else {
           _selectedImg.image = [UIImage imageNamed:@"icon_radio_normal"];
    }
    
    [self setNeedsDisplay];
}

@end
