//
//  BRChoseCacheView.m
//  bookReader
//
//  Created by Jobs on 2021/1/21.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRChoseCacheView.h"
#import "CFCustomMacros.h"
#import "CFUtils.h"
#import <Masonry/Masonry.h>

@interface BRChoseCacheView ()<UIGestureRecognizerDelegate> {
    UIView *_choseBgView;
    UILabel *_startChapterLabel;
    UIButton *_button50;
    UIButton *_button200;
    UIButton *_buttonAll;
    UIButton *_selectedButton;
}

@end

@implementation BRChoseCacheView

- (instancetype)init{
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        self.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0.8);
        
        _choseBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 240/375.f *self.frame.size.width)];
        _choseBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _choseBgView.layer.cornerRadius = 18;
        _choseBgView.clipsToBounds = YES;
        [self addSubview:_choseBgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
        titleLabel.text = @"缓存后续章节";
        [_choseBgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(18);
        }];
        
        _startChapterLabel = [[UILabel alloc] init];
        _startChapterLabel.font = [UIFont systemFontOfSize:14];
        _startChapterLabel.textColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
        _startChapterLabel.text = @"起始章节：";
        [_choseBgView addSubview:_startChapterLabel];
        [_startChapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
        }];
        
        _button50 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button50 setBackgroundImage:[CFUtils pureColorImage:0xE7EFFF colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateSelected];
        [_button50 setBackgroundImage:[CFUtils pureColorImage:0xE7EFFF colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateHighlighted];
        [_button50 setBackgroundImage:[CFUtils pureColorImage:0xF4F4F4 colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateNormal];
        [_button50 setTitle:@"后50章" forState:UIControlStateNormal];
        [_button50 setTitle:@"后50章" forState:UIControlStateSelected];
        _button50.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button50 setTitleColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1) forState:UIControlStateSelected];
        [_button50 setTitleColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1) forState:UIControlStateHighlighted];
        [_button50 setTitleColor:CFUIColorFromRGBAInHex(0x161C2C, 1) forState:UIControlStateNormal];
        _button50.selected = YES;
        _selectedButton= _button50;
        [_button50 addTarget:self action:@selector(clickChoseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBgView addSubview:_button50];
        
        _button200 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button200 setBackgroundImage:[CFUtils pureColorImage:0xE7EFFF colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateSelected];
        [_button200 setBackgroundImage:[CFUtils pureColorImage:0xF4F4F4 colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateNormal];
        [_button200 setBackgroundImage:[CFUtils pureColorImage:0xE7EFFF colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateHighlighted];
        [_button200 setTitle:@"后200章" forState:UIControlStateNormal];
        _button200.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button200 setTitleColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1) forState:UIControlStateSelected];
        [_button200 setTitleColor:CFUIColorFromRGBAInHex(0x161C2C, 1) forState:UIControlStateNormal];
        [_button200 setTitleColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1) forState:UIControlStateHighlighted];
        [_button200 addTarget:self action:@selector(clickChoseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBgView addSubview:_button200];
        
        _buttonAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonAll setBackgroundImage:[CFUtils pureColorImage:0xE7EFFF colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateSelected];
        [_buttonAll setBackgroundImage:[CFUtils pureColorImage:0xF4F4F4 colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateNormal];
        [_buttonAll setBackgroundImage:[CFUtils pureColorImage:0xE7EFFF colorAlpha:1 size:CGSizeMake(105, 62)] forState:UIControlStateHighlighted];
        [_buttonAll setTitle:@"全本缓存" forState:UIControlStateNormal];
        _buttonAll.titleLabel.font = [UIFont systemFontOfSize:16];
        [_buttonAll setTitleColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1) forState:UIControlStateSelected];
        [_buttonAll setTitleColor:CFUIColorFromRGBAInHex(0x161C2C, 1) forState:UIControlStateNormal];
        [_buttonAll addTarget:self action:@selector(clickChoseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonAll setTitleColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1) forState:UIControlStateHighlighted];
        [_choseBgView addSubview:_buttonAll];
        
        
        UIButton *cacheButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cacheButton setBackgroundColor:CFUIColorFromRGBAInHex(0x4C8BFF, 1)];
        cacheButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cacheButton setTitleColor:CFUIColorFromRGBAInHex(0xffffff, 1) forState:UIControlStateNormal];
        [cacheButton setTitle:@"加入缓存" forState:UIControlStateNormal];
        cacheButton.clipsToBounds = YES;
        cacheButton.layer.cornerRadius = 20.f;
        [cacheButton addTarget:self action:@selector(clickCacheButton:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBgView addSubview:cacheButton];
        [cacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-25);
        }];
        
        NSArray *_masonryBtnsArray = @[_button50, _button200, _buttonAll];
        
        [_masonryBtnsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:105 leadSpacing:20 tailSpacing:20];
           // 设置array的垂直方向的约束
        [_masonryBtnsArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_startChapterLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(62);
            make.width.mas_equalTo(105);
        }];
        
    }
    
    return self;
}


- (void)show{
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat height = _choseBgView.frame.size.height;
    
    
    _choseBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0.8);
        self->_choseBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - height, self.frame.size.width, height);
    }];
}

- (void)dismiss{
    if (self.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self->_choseBgView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self->_choseBgView.frame.size.height);
            self.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0);
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    }
}

- (void)tap:(UITapGestureRecognizer *)tapGes {
    [self dismiss];
}

- (void)clickChoseButton:(UIButton *)button {
    _selectedButton.selected = NO;
    _selectedButton = button;
    _selectedButton.selected = YES;
}

- (void)clickCacheButton:(UIButton *)button {
    NSInteger count = 0;
    if (_selectedButton == _button50) {
        count = 50;
    } else if (_selectedButton == _button200) {
        count = 200;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseCacheViewClickCacheButtonWithChapter:count:)]) {
        [self.delegate choseCacheViewClickCacheButtonWithChapter:self.allChapters count:count];
    }
    [self dismiss];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view == _choseBgView){
        return NO;
    }else {
        return YES;
    }
}



@end
