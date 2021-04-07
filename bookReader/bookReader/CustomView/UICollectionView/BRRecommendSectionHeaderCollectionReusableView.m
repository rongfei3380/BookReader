//
//  BRRecommendSectionHeaderCollectionReusableView.m
//  bookReader
//
//  Created by chengfei on 2021/4/6.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRRecommendSectionHeaderCollectionReusableView.h"
#import <Masonry/Masonry.h>
#import "CFCustomMacros.h"

@implementation BRRecommendSectionHeaderCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 0);
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        [self addSubview:_titleLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_offset(22);
    }];   
}

- (void)setSectionHeader:(NSString *)text {
    _titleLabel.text = text;
}

@end
