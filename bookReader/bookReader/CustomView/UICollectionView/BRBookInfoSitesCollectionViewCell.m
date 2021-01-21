//
//  BRBookInfoSitesCollectionViewCell.m
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookInfoSitesCollectionViewCell.h"
#import "CFCustomMacros.h"
#import <Masonry.h>
#import "CFDataUtils.h"

@interface BRBookInfoSitesCollectionViewCell () {
    UILabel *_siteLabel;
    UILabel *_lastChapterLabel;
    UILabel *_updateTimeLabel;
    NSInteger _selectedSiteIndex;
}

@end

@implementation BRBookInfoSitesCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        
        _siteLabel = [UILabel new];
//        _siteLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _siteLabel.font = [UIFont systemFontOfSize:14];
        _siteLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        [self.contentView addSubview:_siteLabel];
        [_siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(11);
            make.right.mas_equalTo(-11);
            make.height.mas_equalTo(20);
        }];
        
        _lastChapterLabel = [UILabel new];
//        _lastChapterLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
        _lastChapterLabel.font = [UIFont boldSystemFontOfSize:16];
        _lastChapterLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        [self.contentView addSubview:_lastChapterLabel];
        [_lastChapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_siteLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(11);
            make.right.mas_equalTo(-11);
            make.height.mas_equalTo(20);
        }];

        
        if (!_updateTimeLabel) {
            _updateTimeLabel = [UILabel new];
            _updateTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
            _updateTimeLabel.numberOfLines = 0;
            _updateTimeLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
            [self.contentView addSubview:_updateTimeLabel];
            [_updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(11);
                make.top.equalTo(_lastChapterLabel.mas_bottom).offset(5);
                make.height.offset(20);
                make.right.offset(-11);
            }];
        }
        
        UIImageView *arrowImg = [[UIImageView alloc] init];
        arrowImg.image = [UIImage imageNamed:@"icon_arrow_right"];
        [self.contentView addSubview:arrowImg];
        [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(10, 18));
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = CFUIColorFromRGBAInHex(0xF8F6F9, 1);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(7);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo{
    _bookInfo = bookInfo;
    
    BRSite *selectedSite = [self getSelectedSiteDate];
    
    NSMutableAttributedString *attributedString = nil;
    if (selectedSite.siteName) {
        NSString *count = [NSString stringWithFormat:@"%ld", self.bookInfo.sitesArray.count];
        NSString *siteStr = [NSString stringWithFormat:@"共有%@个书源，当前源：%@", count, selectedSite.siteName];
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:siteStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:(5 - (_siteLabel.font.lineHeight - _siteLabel.font.pointSize))];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [selectedSite.siteName length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:CFUIColorFromRGBAInHex(0x4C8BFF, 1)  range:[siteStr rangeOfString:count]];
        
    }
    _siteLabel.attributedText = attributedString;
    
    BRSite *site = [self getTheLastSite];
    NSMutableAttributedString *lastChapterAttributedString = nil;
    if (site.lastChapterName) {
        NSString *new = @"最新";
        NSString *siteStr = [NSString stringWithFormat:@"%@      %@", new, site.lastChapterName];
        
        lastChapterAttributedString = [[NSMutableAttributedString alloc] initWithString:siteStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:(5 - (_siteLabel.font.lineHeight - _siteLabel.font.pointSize))];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [lastChapterAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [siteStr length])];
        [lastChapterAttributedString addAttribute:NSForegroundColorAttributeName value:CFUIColorFromRGBAInHex(0x4C8BFF, 1)  range:[siteStr rangeOfString:new]];
    }
    _lastChapterLabel.attributedText = lastChapterAttributedString;
    
    NSString *updateTime = [NSString stringWithFormat:@"更新于%@", [CFDataUtils createBookUpdateTime:site.lastupdateDate]];
    _updateTimeLabel.text = updateTime;
    
    
//    _siteLabel.text = [NSString stringWithFormat:@"共有%ld个书源，当前源：%@", self.bookInfo.sitesArray.count, site.siteName];
    
}

- (BRSite *)getTheLastSite {
    BRSite *lastSite = [_bookInfo.sitesArray firstObject];
    for (BRSite *site in _bookInfo.sitesArray) {
        if (lastSite.oid.intValue >= site.oid.intValue) {
            
        } else {
            lastSite = site;
        }
    }
    return lastSite;
}

- (BRSite *)getSelectedSiteDate {
    BRSite *site = nil;
    _selectedSiteIndex = self.bookInfo.siteIndex.intValue;
    if (_selectedSiteIndex >= 0) {
        if (_selectedSiteIndex >= self.bookInfo.sitesArray.count) {
            _selectedSiteIndex = self.bookInfo.sitesArray.count -1;
        }
        site = [self.bookInfo.sitesArray objectAtIndex:_selectedSiteIndex];
    } else {
        site = [self.bookInfo.sitesArray firstObject];
    }
    
    site.isSelected  = [NSNumber numberWithBool:YES];
    
    self.bookInfo.siteIndex = @(_selectedSiteIndex);
    return site;
}

@end
