//
//  BRRecommendCollectionReusableView.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRRecommendCollectionReusableView.h"
#import "CFButtonUpDwon.h"
#import "CFCustomMacros.h"
#import <Masonry/Masonry.h>
#import "ZKCycleScrollView.h"
#import "BRCycleCollectionViewCell.h"

@interface BRRecommendCollectionReusableView ()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>{
    NSArray *_masonryBtnsArray;
    UIView *_searchViewBg;
    ZKCycleScrollView *cycleScrollView;
    UILabel *_titleLabel;
}
@end

@implementation BRRecommendCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 0);
        
        _searchViewBg = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH -15*2, 33)];
        _searchViewBg.backgroundColor = CFUIColorFromRGBAInHex(0xF8F6F9, 1);
        _searchViewBg.layer.cornerRadius = 16.5;
        [self addSubview:_searchViewBg];
        
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"con_search"];
        [_searchViewBg addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11.5);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.centerY.mas_equalTo(0);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        label.textColor = CFUIColorFromRGBAInHex(0xB5B5B9, 1);
        label.text = @"搜索书名/作者名";
        [_searchViewBg addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(38);
            make.right.mas_equalTo(-38);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)] ;
        [_searchViewBg addGestureRecognizer:tap];
        
        cycleScrollView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_searchViewBg.frame) +15, SCREEN_WIDTH-20*2, (130/345.f)*(SCREEN_WIDTH -20*2))];
        cycleScrollView.backgroundColor = [UIColor clearColor];
        cycleScrollView.delegate = self;
        cycleScrollView.dataSource = self;
        cycleScrollView.clipsToBounds = YES;
        cycleScrollView.layer.cornerRadius = 8.f;
        [cycleScrollView registerCellClass:[BRCycleCollectionViewCell class] forCellWithReuseIdentifier:@"BRCycleCollectionViewCell"];
        [self addSubview:cycleScrollView];
        
        
        CFButtonUpDwon *popularBtn = [self btnWithTitle:@"人气榜" Image:@"ranking_popularity_list"];
        popularBtn.tag = 1000;
        
//        CFButtonUpDwon *hotBtn = [self btnWithTitle:@"热搜榜" Image:@"ranking_hot_search"];
//        hotBtn.tag = 1001;
        
        CFButtonUpDwon *highBtn = [self btnWithTitle:@"收藏榜" Image:@"ranking_high_opinion"];
        highBtn.tag = 1002;
        
        CFButtonUpDwon *newBtn = [self btnWithTitle:@"新书榜" Image:@"ranking_new_book"];
        newBtn.tag = 1003;
        
        CFButtonUpDwon *endBtn = [self btnWithTitle:@"完结榜" Image:@"ranking_end_list"];
        endBtn.tag = 1004;
        
        [self addSubview:popularBtn];
//        [self addSubview:hotBtn];
        [self addSubview:highBtn];
        [self addSubview:newBtn];
        [self addSubview:endBtn];
        
        _masonryBtnsArray = @[popularBtn, highBtn, newBtn, endBtn];
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        _titleLabel.text = @"重磅推荐";
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_masonryBtnsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:40 leadSpacing:20 tailSpacing:20];
       // 设置array的垂直方向的约束
    [_masonryBtnsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cycleScrollView.mas_bottom).offset(22);
        make.height.mas_equalTo(50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(cycleScrollView.mas_bottom).offset(95);
        make.height.mas_offset(22);
    }];
    
}

- (void)setBooksArray:(NSArray<BRBookInfoModel *> *)booksArray {
    _booksArray = booksArray;
    
    [cycleScrollView reloadData];
    [self setNeedsLayout];
}

- (void)clickActionButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendCollectionReusableViewActionButtonsClick:title:)]) {
        [self.delegate recommendCollectionReusableViewActionButtonsClick:sender.tag -1000 title:sender.titleLabel.text];
    }
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tapGest{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendCollectionReusableViewTapSearch)]) {
        [self.delegate recommendCollectionReusableViewTapSearch];
    }
}


#pragma mark- private

- (CFButtonUpDwon*)btnWithTitle:(NSString*)title Image:(NSString *)image{
    
    CFButtonUpDwon* btn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
//    btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC" size:12];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:CFUIColorFromRGBAInHex(0x333333, 1) forState:UIControlStateNormal];
    return btn;
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    return _booksArray.count;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
   BRCycleCollectionViewCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:@"BRCycleCollectionViewCell" forIndex:index];

    cell.bookInfo = [_booksArray objectAtIndex:index];
    
   return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // TODO:
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollViewDidSelectItemAtIndex:)]) {
        [self.delegate cycleScrollViewDidSelectItemAtIndex:index];
    }
}

@end
