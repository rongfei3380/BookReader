//
//  BRBookReadTextTableViewCell.m
//  bookReader
//
//  Created by chengfei on 2021/2/27.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookReadTextTableViewCell.h"
#import "BRBookReadTextView.h"
#import <Masonry.h>
#import "GVUserDefaults+BRUserDefaults.h"
#import "CFReadViewMacros.h"

@interface BRBookReadTextTableViewCell () {
    BRBookReadTextView *_readContentView;
}

@end

@implementation BRBookReadTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _readContentView = [[BRBookReadTextView alloc] init];
        _readContentView.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_readContentView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_readContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kChapterNameLabelHeight+ kReadContentOffSetY);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setText:(NSString *)text {
    _text = text;
    _readContentView.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
