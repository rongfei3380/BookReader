//
//  BRBookReadContenViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookReadContenViewController.h"
#import "BRBookReadTextView.h"
#import "GVUserDefaults+BRUserDefaults.h"
#import "BRNotificationMacros.h"
#import "CFCustomMacros.h"
#import <Masonry.h>
#import "NSDate+Utilities.h"
#import "CFReadViewMacros.h"

@interface BRBookReadContenViewController ()

@property (nonatomic,strong) BRBookReadTextView* contentView;
@property (nonatomic,strong) UILabel* chapterNameLabel;
@property (nonatomic,strong) UILabel* indexLabel;
@property (nonatomic,strong) UILabel* timeLabel;

@end

@implementation BRBookReadContenViewController

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStyleScroll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReadContentTouchEnd object:nil];
    }
}

- (instancetype)initWithText:(NSString*)text chapterName:(NSString*)chapterName totalNum:(NSInteger)totalNum index:(NSInteger)index {
    self = [super init];
    if(self) {
        self.text           = text;
        self.chapterName    = chapterName;
        self.totalNum       = totalNum;
        self.index          = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialSubViews];
    [self initialSubViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (BRUserDefault.isNightStyle){
        self.view.backgroundColor   = CFUIColorFromRGBAInHex(0x171a21, 1);
        _chapterNameLabel.textColor = CFUIColorFromRGBAInHex(0x576071, 1);
        _indexLabel.textColor       = CFUIColorFromRGBAInHex(0x576071, 1);
        _timeLabel.textColor        = CFUIColorFromRGBAInHex(0x576071, 1);
    }
    
    [self initialData];
}


- (void)initialSubViews
{
    _contentView = [[BRBookReadTextView alloc] initWithText:_text];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    self.view.backgroundColor = BRUserDefault.readBackColor ? : CFUIColorFromRGBAInHex(0xFFFFFF, 1);
    
    _chapterNameLabel = [[UILabel alloc] init];
    _chapterNameLabel.text = self.chapterName;
    _chapterNameLabel.font = [UIFont systemFontOfSize:12];
    _chapterNameLabel.textColor = BRUserDefault.readInfoColor ? : CFUIColorFromRGBAInHex(0x8F9396, 1);
    [self.view addSubview:_chapterNameLabel];
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.textColor  = BRUserDefault.readInfoColor?:CFUIColorFromRGBAInHex(0x8F9396, 1);
    _indexLabel.text = [NSString stringWithFormat:@"第%ld/%ld页",self.index,self.totalNum];
    _indexLabel.font = [UIFont systemFontOfSize:12];
    _indexLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_indexLabel];
    
//    _timeLabel = [[UILabel alloc] init];
//    _timeLabel.font = [UIFont systemFontOfSize:12];
//    _timeLabel.textColor = BRUserDefault.readInfoColor?:CFUIColorFromRGBAInHex(0x8F9396, 1);
//    [self.view addSubview:_timeLabel];
    
    [self initialData];
}

- (void)initialSubViewConstraints {
    [_chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight());
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(kChapterNameLabelHeight);
    }];
    
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(150);
    }];
    
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-8);
//        make.left.mas_equalTo(15);
//        make.right.equalTo(self->_indexLabel.mas_left).offset(-8);
//    }];
    
    CGFloat offSetBottom = kReadStatusHeight*(-1);
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_chapterNameLabel.mas_bottom).offset(kReadContentOffSetY);
        make.bottom.mas_equalTo(offSetBottom);
    }];
    
    
}

- (void)initialData {
    _timeLabel.text = [[NSDate date] shortString];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/**
 * 生成页面"背面图"
 */
- (UIViewController*)backImageV {
    UIViewController* bvc = [[UIViewController alloc] init];
    bvc.view.backgroundColor = self.view.backgroundColor;

    CGRect rect = self.view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMake(-1.0, 0, 0, 1.0, rect.size.width, 0.0);
    CGContextConcatCTM(context, transform);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* imageV = [[UIImageView alloc] initWithImage:screenshot];
    imageV.frame = self.view.bounds;
    imageV.alpha = 0.5;
    [bvc.view addSubview:imageV];
    
    return bvc;
}

- (UIViewController *)backVC {
    return [self backImageV];
}

@end
