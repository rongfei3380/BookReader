//
//  BRChaptersTableViewCell.m
//  bookReader
//
//  Created by chengfei on 2021/1/29.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRChaptersTableViewCell.h"
#import "CFCustomMacros.h"
#import <Masonry/Masonry.h>
#import "CFDataUtils.h"
#import "BRDataBaseManager.h"
#import "BRChapterDetail.h"


@implementation BRChaptersTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        _chapterNameLabel = [[UILabel alloc] init];
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0x414653, 1);
        _chapterNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_chapterNameLabel];
        
        _cacheStateLabel = [[UILabel alloc] init];
        _cacheStateLabel.textColor = CFUIColorFromRGBAInHex(0x9196aa, 1);
        _cacheStateLabel.font = [UIFont systemFontOfSize:14];
        _cacheStateLabel.textAlignment = NSTextAlignmentRight;
        _cacheStateLabel.text = @"已缓存";
        [self.contentView addSubview:_cacheStateLabel];
        
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
    
    [_cacheStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-29);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChapter:(BRChapter *)chapter {
    _chapter = chapter;
    _chapterNameLabel.text = _chapter.name;
    
    BRChapterDetail *chapterDetail = [[BRDataBaseManager sharedInstance] selectChapterContentWithChapterId:chapter.chapterId];
    
    if (chapterDetail.content == nil || chapterDetail.content.length == 0) {
        _cacheStateLabel.hidden = YES;
        [_chapterNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
        }];
    } else {
        [_chapterNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-80);
        }];
        _cacheStateLabel.hidden = NO;
    }
}

- (void)setIsCurrentIndex:(BOOL)isCurrentIndex {
    _isCurrentIndex = isCurrentIndex;
    if (_isCurrentIndex){
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0xFFA317, 1);
    } else{
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0x414653, 1);
    }
}

@end
