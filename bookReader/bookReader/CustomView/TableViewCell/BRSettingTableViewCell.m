//
//  BRSettingTableViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/8/3.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSettingTableViewCell.h"
#import "CFCustomMacros.h"
#import <Masonry.h>

@interface BRSettingTableViewCell () {
    UIImageView *_iconImg;
    UILabel *_titleLabel;
}

@end

@implementation BRSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImg = [[UIImageView alloc] init];
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImg];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImg.mas_right).offset(10);
        make.centerY.mas_offset(0);
        make.right.mas_equalTo(-100);
    }];
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    _iconImg.image = [UIImage imageNamed:icon];
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    [self setNeedsDisplay];
}


@end
