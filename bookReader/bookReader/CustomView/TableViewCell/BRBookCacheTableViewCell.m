//
//  BRBookCacheTableViewCell.m
//  bookReader
//
//  Created by Jobs on 2021/1/11.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookCacheTableViewCell.h"
#import "CFCustomMacros.h"
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>
#import "BRDataCacheOperation.h"
#import "BRDataBaseCacheManager.h"

@interface BRBookCacheTableViewCell (){
    
    UIImageView *_coverImgView;
    UILabel *_bookNameLabel;
    UILabel *_progressLabel;
    UILabel *_cacheStateLabel;
    UIProgressView *_progressView;
    UIButton *_controlBtn;
    UIButton *_deleteBtn;
}

@end

@implementation BRBookCacheTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.clipsToBounds = YES;
        _coverImgView.layer.cornerRadius = 3.f;
        [self.contentView addSubview:_coverImgView];
        
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x000000, 1);
        [self.contentView addSubview:_bookNameLabel];
        
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _progressLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        [self.contentView addSubview:_progressLabel];
        
        _cacheStateLabel = [[UILabel alloc] init];
        _cacheStateLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _cacheStateLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        _cacheStateLabel.text = @"等待下载";
        [self.contentView addSubview:_cacheStateLabel];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"btn_control_cancel"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        
        _controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_controlBtn setImage:[UIImage imageNamed:@"btn_control_start"] forState:UIControlStateNormal];
        [_controlBtn setImage:[UIImage imageNamed:@"btn_control_suspended"] forState:UIControlStateSelected];
        [_controlBtn addTarget:self action:@selector(clickControlButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_controlBtn];
        
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1);
        _progressView.trackTintColor = CFUIColorFromRGBAInHex(0xE7E7E7, 1);
        _progressView.progress = 0;
        [self.contentView addSubview:_progressView];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 80));
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverImgView.mas_top).offset(11.5);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(20);
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bookNameLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(12);
        make.right.mas_equalTo(-200);
        make.height.mas_equalTo(20);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_deleteBtn.mas_left).offset(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_cacheStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_progressLabel.mas_centerY).offset(0);
        make.right.mas_equalTo(_controlBtn.mas_left).offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(-14);
        make.height.mas_equalTo(4);
        make.left.mas_equalTo(_coverImgView.mas_right).offset(12);
        make.right.mas_equalTo(_controlBtn.mas_left).offset(-30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCacheTask:(BRCacheTask *)cacheTask {
    _cacheTask = cacheTask;
    
    [_coverImgView yy_setImageWithURL:[NSURL URLWithString:_cacheTask.cover] placeholder:[UIImage imageNamed:@"img_book_placehold"]];
    _bookNameLabel.text = _cacheTask.bookName;
    if (cacheTask.state == BRCacheTaskStateCompleted) {
        _progressLabel.text = [NSString stringWithFormat:@"共%ld章",[_cacheTask allChapterCount]];
        _cacheStateLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        _cacheStateLabel.text = @"已完成";
        _controlBtn.hidden = YES;
    } else {
        _controlBtn.hidden = NO;
        _progressLabel.text = [NSString stringWithFormat:@"%ld/%ld",_cacheTask.cachedChapterIds.count, [_cacheTask allChapterCount]];
        _cacheStateLabel.text = @"正在下载";
        _cacheStateLabel.textColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1);
    }
    
    if(cacheTask.state == BRCacheTaskStateDownloading) {
        _controlBtn.selected = YES;
    } else {
        _controlBtn.selected = NO;
    }
    
    
    float cachedNum = (float)(_cacheTask.cachedChapterIds.count);
    float progress = cachedNum/(float)([_cacheTask allChapterCount]);
    _progressView.progress = progress;
        
    NSString *key = [NSString stringWithFormat:@"%@+%@", _cacheTask.bookId, _cacheTask.siteId];
    BRDataCacheOperation *operation = [[BRDataBaseCacheManager sharedInstance].cacheOperations objectForKey:key];
    cacheTask.cacheProgressBlock= ^(NSInteger receivedCount, NSInteger expectedCount, BRCacheTask * _Nullable task){
        kdispatch_main_sync_safe(^{
            [self updateProgress];
        });
    };
    cacheTask.cacheCompletedBlock = ^(BRCacheTask * _Nullable task, NSError * _Nullable NSError, BOOL finished){
        kdispatch_main_sync_safe(^{
            [self cacheCompleted];
        });
        
    };
    [operation addHandlersForProgress:cacheTask.cacheProgressBlock completed:cacheTask.cacheCompletedBlock];
        
        
    [self setNeedsDisplay];
}

- (void)updateProgress {
    self->_progressLabel.text = [NSString stringWithFormat:@"%ld/%ld",_cacheTask.cachedChapterIds.count, [_cacheTask allChapterCount]];
    float cachedNum = (float)(_cacheTask.cachedChapterIds.count);
    float progress = cachedNum/(float)([_cacheTask allChapterCount]);
    _progressView.progress = progress;
    _cacheStateLabel.text = @"正在下载";
    _controlBtn.hidden = NO;
    _cacheStateLabel.textColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1);
}

- (void)cacheCompleted {
    _progressView.progress = 1.0f;
    _progressLabel.text = [NSString stringWithFormat:@"共%ld章",[_cacheTask allChapterCount]];
    _cacheTask.state = BRCacheTaskStateCompleted;
    _cacheStateLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
    _cacheStateLabel.text = @"已完成";
    _controlBtn.hidden = YES;
}

#pragma mark- button Methods

- (void)clickControlButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCacheTableViewCellClickControlButton:cacheTask:)]) {
        [self.delegate bookCacheTableViewCellClickControlButton:button cacheTask:_cacheTask];
    }
}

- (void)clickDeleteButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookCacheTableViewCellClickDeleteButton:cacheTask:)]) {
        [self.delegate bookCacheTableViewCellClickDeleteButton:button cacheTask:_cacheTask];
    }
}

@end
