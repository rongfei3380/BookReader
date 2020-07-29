//
//  BRCycleCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2020/7/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRCycleCollectionViewCell.h"
#import <YYWebImage.h>
#import "CFCustomMacros.h"
#import <Masonry.h>

@interface BRCycleCollectionViewCell () {
    UIImageView *_coverImageView;
}

@end

@implementation BRCycleCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_coverImageView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_offset(0);
        }];
        
    }
    return self;
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    [_coverImageView yy_setImageWithURL:[NSURL URLWithString:_bookInfo.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
}


@end
