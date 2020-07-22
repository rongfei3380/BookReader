//
//  BRSearchCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSearchCollectionViewCell.h"
#import <Masonry.h>
#import "CFCustomMacros.h"

@interface  BRSearchCollectionViewCell () {
    UILabel *_searchLabel;
}

@end

@implementation BRSearchCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"icon_search_recommend"];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(16, 17));
        }];
        
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.font = [UIFont systemFontOfSize:13];
        _searchLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [self addSubview:_searchLabel];
        [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(8);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)setSearchString:(NSString *)searchString {
    _searchString = searchString;
    _searchLabel.text = _searchString;
}

@end
