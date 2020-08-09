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
    
    ZKCycleScrollView *cycleScrollView;
}
@end

@implementation BRRecommendCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        cycleScrollView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-20*2, (114/335.f)*(SCREEN_WIDTH -20*2))];
        cycleScrollView.backgroundColor = [UIColor clearColor];
        cycleScrollView.delegate = self;
        cycleScrollView.dataSource = self;
        cycleScrollView.clipsToBounds = YES;
        cycleScrollView.layer.cornerRadius = 8.f;
        [cycleScrollView registerCellClass:[BRCycleCollectionViewCell class] forCellWithReuseIdentifier:@"BRCycleCollectionViewCell"];
        [self addSubview:cycleScrollView];
        
        
        CFButtonUpDwon *popularBtn = [self btnWithTitle:@"人气榜" Image:@"ranking_popularity_list"];
        popularBtn.tag = 1000;
        
        CFButtonUpDwon *hotBtn = [self btnWithTitle:@"热搜榜" Image:@"ranking_hot_search"];
        hotBtn.tag = 1001;
        
        CFButtonUpDwon *highBtn = [self btnWithTitle:@"好评榜" Image:@"ranking_high_opinion"];
        highBtn.tag = 1002;
        
        CFButtonUpDwon *newBtn = [self btnWithTitle:@"新书榜" Image:@"ranking_new_book"];
        newBtn.tag = 1003;
        
        CFButtonUpDwon *endBtn = [self btnWithTitle:@"完结榜" Image:@"ranking_end_list"];
        endBtn.tag = 1004;
        
        [self addSubview:popularBtn];
        [self addSubview:hotBtn];
        [self addSubview:highBtn];
        [self addSubview:newBtn];
        [self addSubview:endBtn];
        
        _masonryBtnsArray = @[popularBtn, hotBtn, highBtn, newBtn, endBtn];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = CFUIColorFromRGBAInHex(0xF5F5F5, 1);
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(8);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_masonryBtnsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:40 leadSpacing:20 tailSpacing:20];
       // 设置array的垂直方向的约束
    [_masonryBtnsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(55);
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

#pragma mark- private

- (CFButtonUpDwon*)btnWithTitle:(NSString*)title Image:(NSString *)image{
    
    CFButtonUpDwon* btn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:CFUIColorFromRGBAInHex(0x666666, 1) forState:UIControlStateNormal];
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
