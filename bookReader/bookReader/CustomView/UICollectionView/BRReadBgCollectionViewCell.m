//
//  BRReadBgCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/9/17.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRReadBgCollectionViewCell.h"
#import "CFCustomMacros.h"
#import <Masonry.h>

@implementation BRReadBgCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgImg = [[UIImageView alloc] init];
        _bgImg.userInteractionEnabled = YES;
        [self addSubview:_bgImg];
        _bgImg.clipsToBounds = YES;
        _bgImg.layer.cornerRadius = 14;
        _bgImg.layer.borderWidth = 0.5;
        _bgImg.layer.borderColor = [UIColor lightGrayColor].CGColor;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)setBackImage:(UIImage * _Nonnull)backImage isSelected:(BOOL)selected {
    _bgImg.image = backImage;
    if (selected) {
        _bgImg.layer.borderColor = CFUIColorFromRGBAInHex(0xFEB038, 1).CGColor;
        _bgImg.layer.borderWidth = 2.0;

    } else {
        _bgImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bgImg.layer.borderWidth = 0.5;
    }
}


@end
