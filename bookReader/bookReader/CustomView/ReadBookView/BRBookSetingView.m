//
//  BRBookSetingView.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookSetingView.h"
#import "CFCustomMacros.h"
#import "Masonry.h"
#import "GVUserDefaults+BRUserDefaults.h"
#import "BRReadBgCollectionViewCell.h"
#import "CFUtils.h"



@interface BRBookSetingView () <UICollectionViewDelegate, UICollectionViewDataSource>

/* 字号*/
@property (nonatomic,strong) UILabel* fontTitleLabel;
@property (nonatomic,strong) UIButton* fontSubBtn;
@property (nonatomic,strong) UILabel* fontSizeLabel;
@property (nonatomic,strong) UIButton* fontAddBtn;

/* 间距*/
@property (nonatomic,strong) UILabel* spaceTitleLabel;
@property (nonatomic,strong) UIButton* spaceBtn1;
@property (nonatomic,strong) UIButton* spaceBtn2;
@property (nonatomic,strong) UIButton* spaceBtn3;
//@property (nonatomic,strong) UIButton* spaceBtn4;

/* 翻页*/
@property (nonatomic,strong) UILabel* transitionTitleLabel;
@property (nonatomic,strong) UIButton* tranPageCurlBtn;
@property (nonatomic,strong) UIButton* tranScrollBtn;

/* 亮度*/
@property (nonatomic,strong) UILabel* lightTitleLabel;
@property (nonatomic,strong) UISlider* lightSlider;

/* 背景*/
@property (nonatomic,strong) UILabel* backTitleLabel;
@property (nonatomic,strong) UICollectionView *backBgCollectionView;


//@property (nonatomic,strong) UIButton* backBtn1;
//@property (nonatomic,strong) UIButton* backBtn2;
//@property (nonatomic,strong) UIButton* backBtn3;
//@property (nonatomic,strong) UIButton* backBtn4;
//
//@property (nonatomic,strong) UIButton* backBtn5;
//@property (nonatomic,strong) UIButton* backBtn6;
//@property (nonatomic,strong) UIButton* backBtn7;
//@property (nonatomic,strong) UIButton* backBtn8;

@property(nonatomic, strong) NSArray *bgIconArray;
@property(nonatomic, strong) NSMutableArray *bgSelectedArray;
@property(nonatomic, strong) NSArray *bgImageArray;

@end

@implementation BRBookSetingView

#pragma mark- super
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (instancetype)init{
    self = [super init];
    if (self){
        [self initialSubViews];
        [self initSubViewConstraints];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self.backBgCollectionView reloadData];
}

#pragma mark- private

- (void)initialSubViews {
    self.backgroundColor = CFUIColorFromRGBAInHex(0xFFFFFF, 1);
    
    _fontTitleLabel = [self titleLabelWithTitle:@"字号"];
    [self addSubview:_fontTitleLabel];

        
    _fontSubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fontSubBtn.backgroundColor = CFUIColorFromRGBAInHex(0xEFEFEF, 1);
    _fontSubBtn.layer.cornerRadius = 10;
    _fontSubBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_fontSubBtn setTitle:@"A-" forState:UIControlStateNormal];
    [_fontSubBtn setTitleColor:CFUIColorFromRGBAInHex(0x333333, 1) forState:UIControlStateNormal];
    [_fontSubBtn addTarget:self action:@selector(fontSizeDownClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fontSubBtn];
    
    _fontSizeLabel = [self titleLabelWithTitle:@"20"];
    [self addSubview:_fontSizeLabel];
    [self reloadFontLable];
    
    _fontAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fontAddBtn.backgroundColor = CFUIColorFromRGBAInHex(0xEFEFEF, 1);
    _fontAddBtn.layer.cornerRadius = 10;
    _fontAddBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_fontAddBtn setTitle:@"A+" forState:UIControlStateNormal];
    [_fontAddBtn setTitleColor:CFUIColorFromRGBAInHex(0x333333, 1) forState:UIControlStateNormal];
    [_fontAddBtn addTarget:self action:@selector(fontSizeUpClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fontAddBtn];
    
    _spaceTitleLabel = [self titleLabelWithTitle:@"间距"];
    [self addSubview:_spaceTitleLabel];
    
    _spaceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_spaceBtn1 addTarget:self action:@selector(lineSpacingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_spaceBtn1 setImage:[UIImage imageNamed:@"reading_spacing_five"] forState:UIControlStateNormal];
    [self addSubview:_spaceBtn1];
    
    _spaceBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_spaceBtn2 addTarget:self action:@selector(lineSpacingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_spaceBtn2 setImage:[UIImage imageNamed:@"reading_spacing_four"] forState:UIControlStateNormal];
    [self addSubview:_spaceBtn2];
    
    _spaceBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_spaceBtn3 addTarget:self action:@selector(lineSpacingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_spaceBtn3 setImage:[UIImage imageNamed:@"reading_spacing_three"] forState:UIControlStateNormal];
    [self addSubview:_spaceBtn3];
    
//    _spaceBtn4 = [self btnWithTitle:@""];
//    [_spaceBtn4 addTarget:self action:@selector(lineSpacingClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_spaceBtn4 setImage:[UIImage imageNamed:@"space_4"] forState:UIControlStateNormal];
//    [self addSubview:_spaceBtn4];
    
//    _transitionTitleLabel = [self titleLabelWithTitle:@"翻页"];
//    [self addSubview:_transitionTitleLabel];
    

    _tranPageCurlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tranPageCurlBtn setTitle:@"仿真" forState:UIControlStateNormal];
    _tranPageCurlBtn.clipsToBounds = YES;
    _tranPageCurlBtn.layer.cornerRadius  = 10.f;
    [_tranPageCurlBtn setTitleColor:CFUIColorFromRGBAInHex(0x333333, 1) forState:UIControlStateNormal];
    [_tranPageCurlBtn addTarget:self action:@selector(transitionClick:) forControlEvents:UIControlEventTouchUpInside];
    _tranPageCurlBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_tranPageCurlBtn];
    
    _tranScrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tranScrollBtn setTitle:@"滑动" forState:UIControlStateNormal];
    _tranScrollBtn.clipsToBounds = YES;
    [_tranScrollBtn setTitleColor:CFUIColorFromRGBAInHex(0x333333, 1) forState:UIControlStateNormal];
    _tranScrollBtn.layer.cornerRadius  = 10.f;
    [_tranScrollBtn addTarget:self action:@selector(transitionClick:) forControlEvents:UIControlEventTouchUpInside];
    _tranScrollBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_tranScrollBtn];
    
    _lightTitleLabel = [self titleLabelWithTitle:@"亮度"];
    [self addSubview:_lightTitleLabel];
    
    _lightSlider = [[UISlider alloc] init];
    _lightSlider.minimumValue = 0.3;
    _lightSlider.maximumValue = 1;
    _lightSlider.value = 1 -BRUserDefault.readBrightness;
    _lightSlider.minimumValueImage = [UIImage imageNamed:@"setting_sun_l"];
    _lightSlider.maximumValueImage = [UIImage imageNamed:@"setting_sun_s"];
    _lightSlider.minimumTrackTintColor = CFUIColorFromRGBAInHex(0xFEB038, 1);
    _lightSlider.maximumTrackTintColor = CFUIColorFromRGBAInHex(0xEFEFEF, 1);
    _lightSlider.thumbTintColor = CFUIColorFromRGBAInHex(0xFEB038, 1);
    [_lightSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_lightSlider];
    
    _backTitleLabel = [self titleLabelWithTitle:@"背景"];
    [self addSubview:_backTitleLabel];
    
    UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc] init];
    [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _layout.minimumLineSpacing = 19;
    _layout.minimumInteritemSpacing = 1;
    //设置每个item的大小为60*128
    _layout.itemSize = CGSizeMake(28, 28);

    
    self.backBgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    self.backBgCollectionView.backgroundColor = [UIColor clearColor];
    self.backBgCollectionView.delegate = self;
    self.backBgCollectionView.dataSource = self;
    [self addSubview:self.backBgCollectionView];
    
    [self.backBgCollectionView registerClass:[BRReadBgCollectionViewCell class] forCellWithReuseIdentifier:@"BRReadBgCollectionViewCell"];
    
    self.bgIconArray = @[[CFUtils pureColorImage:0xFFFFFF colorAlpha:1 size:CGSizeMake(60, 28)],
                         [CFUtils pureColorImage:0xE5E2D1 colorAlpha:1 size:CGSizeMake(60, 28)],
                         [CFUtils pureColorImage:0xC3CCC2 colorAlpha:1 size:CGSizeMake(60, 28)],
                         [CFUtils pureColorImage:0xDAD9D7 colorAlpha:1 size:CGSizeMake(60, 28)],
                         [CFUtils pureColorImage:0xEEE9E9 colorAlpha:1 size:CGSizeMake(60, 28)],
                         [CFUtils pureColorImage:0xDAE5E8 colorAlpha:1 size:CGSizeMake(60, 28)],
                         [UIImage imageNamed:@"reading_bg_wenli1_def"],
                         [UIImage imageNamed:@"reading_bg_wenli2_def"],
                         [UIImage imageNamed:@"reading_bg_wenli3_def"],
                         [UIImage imageNamed:@"reading_bg_wenli4_def"],
                         [UIImage imageNamed:@"reading_bg_wenli5_def"]];
    
    self.bgSelectedArray = [NSMutableArray array];
    for (int i=0; i<self.bgIconArray.count; i++) {
        if (BRUserDefault.readBackColorIndex == i) {
           [self.bgSelectedArray addObject:[NSNumber numberWithBool:YES]];
        } else {
           [self.bgSelectedArray addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    [self.backBgCollectionView reloadData];
    [self reloadSpaceBtn];
    [self reloadTransition];
    [self reloadBackColor];
}

- (void)initSubViewConstraints {
    
    
    [_spaceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(24.5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(22);
    }];
    
    [_fontTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_spaceTitleLabel.mas_left).offset(0);
        make.top.equalTo(_spaceTitleLabel.mas_bottom).offset(40);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(22);
    }];
    
    [_lightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_fontTitleLabel.mas_left).offset(0);
        make.width.mas_equalTo(30);
        make.top.equalTo(_fontTitleLabel.mas_bottom).offset(40);
        make.height.mas_equalTo(22);
    }];
    
    [_backTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_fontTitleLabel.mas_left).offset(0);
        make.width.mas_equalTo(30);
        make.top.equalTo(_lightTitleLabel.mas_bottom).offset(40);
        make.height.mas_equalTo(22);
    }];
    
//    [_transitionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_fontTitleLabel.mas_left).offset(0);
//        make.width.mas_equalTo(30);
//        make.top.equalTo(_backTitleLabel.mas_bottom).offset(40);
//        make.height.mas_equalTo(22);
//    }];
   
    
    [_fontSubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_fontTitleLabel.mas_centerY).offset(0);
        make.left.equalTo(self.fontTitleLabel.mas_right).offset(20);
        make.height.mas_equalTo(28);
//        make.width.mas_equalTo(70);
    }];
    
    [_fontSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_fontSubBtn.mas_right).offset(5);
//        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(_fontTitleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(22);
    }];
    
    [_fontAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_fontTitleLabel.mas_centerY).offset(0);
        make.left.equalTo(_fontSizeLabel.mas_right).offset(5);
        make.height.mas_equalTo(28);
//        make.width.mas_equalTo(70);
    }];
    
    
     [@[_fontSubBtn, _fontAddBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:114 leadSpacing:80 tailSpacing:24];
  
    
    [@[_spaceBtn3,_spaceBtn2,_spaceBtn1] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:30 leadSpacing:80 tailSpacing:24];
    
    [_spaceBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_spaceTitleLabel.mas_centerY).offset(0);
        make.left.equalTo(self.spaceTitleLabel.mas_right).offset(24);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    [_spaceBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_spaceTitleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    [_spaceBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(_spaceTitleLabel.mas_centerY).offset(0);
           make.right.mas_equalTo(-24);
           make.height.mas_equalTo(20);
           make.width.mas_equalTo(30);
       }];
    
   

    
    
//    [_spaceBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_spaceTitleLabel.mas_centerY).offset(0);
//        make.left.equalTo(self.spaceBtn3.mas_right).offset(8);
//        make.height.mas_equalTo(28);
//        make.width.mas_equalTo(60);
//    }];
    
    [_tranPageCurlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backTitleLabel.mas_bottom).offset(40);
        make.left.mas_equalTo(24);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.mas_centerX).offset(-24);
    }];
    
    [_tranScrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tranPageCurlBtn.mas_centerY).offset(0);
        make.left.equalTo(self.mas_centerX).offset(24);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-24);
    }];
    
    
    
    [_lightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lightTitleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.lightTitleLabel.mas_right).offset(24);
        make.right.mas_equalTo(-24);
    }];
    
   
    
    [self.backBgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(_backTitleLabel.mas_centerY).offset(0);
        make.left.mas_equalTo(_backTitleLabel.mas_right).offset(20);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - init
- (UILabel*)titleLabelWithTitle:(NSString*)title {
    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"PingFang SC" size:15];
    label.text = title;
    label.textColor = CFUIColorFromRGBAInHex(0x333333, 1);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (UIButton*)btnWithTitle:(NSString*)title {
    UIButton* btn = [[UIButton alloc] init];
    btn.backgroundColor = CFUIColorFromRGBAInHex(0xf8f8f8, 1);
    btn.layer.cornerRadius = 14;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.borderColor = CFUIColorFromRGBAInHex(0x838D97, 1).CGColor;
    btn.layer.borderWidth = 0.5;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:CFUIColorFromRGBAInHex(0x313E51, 1) forState:UIControlStateNormal];
    return btn;
}

- (UIButton*)backBtnWithColor:(UIColor*)color {
    UIButton* btn = [[UIButton alloc] init];
    btn.layer.cornerRadius = 14;
    btn.backgroundColor = color;
    btn.layer.borderColor = CFUIColorFromRGBAInHex(0x838D97, 1).CGColor;
    btn.layer.borderWidth = 0.5;
    return btn;
}

#pragma mark - reloadView

- (void)reloadSpaceBtn {
    NSDictionary* dic = BRUserDefault.userReadAttConfig;
    NSMutableParagraphStyle *paragraphStyle = [dic objectForKey:NSParagraphStyleAttributeName];
    
    self.spaceBtn1.backgroundColor = CFUIColorFromRGBAInHex(0xf8f8f8, 1);
    self.spaceBtn2.backgroundColor = CFUIColorFromRGBAInHex(0xf8f8f8, 1);
    self.spaceBtn3.backgroundColor = CFUIColorFromRGBAInHex(0xf8f8f8, 1);
    
    if (paragraphStyle.lineSpacing == kLineSpacingLoose){
        self.spaceBtn3.backgroundColor = CFUIColorFromRGBAInHex(0xd1d1d1, 1);
    }else if (paragraphStyle.lineSpacing == kLineSpacingCompact){
        self.spaceBtn1.backgroundColor = CFUIColorFromRGBAInHex(0xd1d1d1, 1);
    }else {
        self.spaceBtn2.backgroundColor = CFUIColorFromRGBAInHex(0xd1d1d1, 1);
    }
}

- (void)reloadTransition {
    UIPageViewControllerTransitionStyle PageTransitionStyle = BRUserDefault.PageTransitionStyle;
    
    self.tranPageCurlBtn.backgroundColor = CFUIColorFromRGBAInHex(0xEFEFEF, 1);
    self.tranScrollBtn.backgroundColor = CFUIColorFromRGBAInHex(0xEFEFEF, 1);
    
    if (PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl){
        self.tranPageCurlBtn.backgroundColor = CFUIColorFromRGBAInHex(0xFEB038, 1);
    }else{
        self.tranScrollBtn.backgroundColor = CFUIColorFromRGBAInHex(0xFEB038, 1);
    }
}

- (void)reloadBackColor {
    
    for (int i=0; i<self.bgSelectedArray.count; i++) {
        if (BRUserDefault.readBackColorIndex == i) {
            [self.bgSelectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
        } else {
            [self.bgSelectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self.backBgCollectionView reloadData];

}

- (void)reloadFontLable {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:BRUserDefault.userReadAttConfig];
    UIFont* font = [dic objectForKey:NSFontAttributeName];
    float size = font.pointSize;
    if (size == 0) {
        size = KReadFontCustom;
    }
    _fontSizeLabel.text = [NSString stringWithFormat:@"%.0f", size];
}

#pragma mark - target
- (void)sliderValueChange {
    BRUserDefault.readBrightness = 1 -self.lightSlider.value;
    if (self.sliderValueBlock){
        self.sliderValueBlock();
    }
}

- (void)colorBtnClick:(UIButton*)btn {
    
    if (self.block){
        self.block();
    }
    
    [self reloadBackColor];
}

- (void)transitionClick:(UIButton*)btn {
    if (btn==self.tranPageCurlBtn){
        BRUserDefault.PageTransitionStyle = UIPageViewControllerTransitionStylePageCurl;
    }else if (btn==self.tranScrollBtn){
        BRUserDefault.PageTransitionStyle = UIPageViewControllerTransitionStyleScroll;
    }
    
    if (self.block){
        self.block();
    }
    
    [self reloadTransition];
}

- (void)lineSpacingClick:(UIButton*)btn {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:BRUserDefault.userReadAttConfig];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    if (btn == self.spaceBtn1){
        paragraphStyle.lineSpacing = kLineSpacingCompact;
        paragraphStyle.paragraphSpacing = kParagraphSpacingCompact;
    }else if (btn == self.spaceBtn2){
        paragraphStyle.lineSpacing = kLineSpacingCustom;
        paragraphStyle.paragraphSpacing = kParagraphSpacingCustom;
    }else if (btn == self.spaceBtn3){
        paragraphStyle.lineSpacing = kLineSpacingLoose;
        paragraphStyle.paragraphSpacing = kParagraphSpacingLoose;
    }
    [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    BRUserDefault.userReadAttConfig = dic;
    
    if (self.block){
        self.block();
    }
    
    [self reloadSpaceBtn];
}

- (void)fontSizeDownClick {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:BRUserDefault.userReadAttConfig];
    UIFont* font = [dic objectForKey:NSFontAttributeName];
    float size = font.pointSize;
    if (size >= 6){
        UIFont* nweFont = [UIFont systemFontOfSize:size-1];
        [dic setValue:nweFont forKey:NSFontAttributeName];
        BRUserDefault.userReadAttConfig = dic;
        [self reloadFontLable];
    }
    if (self.block){
        self.block();
    }
}

- (void)fontSizeUpClick {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:BRUserDefault.userReadAttConfig];
    UIFont* font = [dic objectForKey:NSFontAttributeName];
    float size = font.pointSize;
    if (size <= 35){
        UIFont* nweFont = [UIFont systemFontOfSize:size+1];
        [dic setValue:nweFont forKey:NSFontAttributeName];
        BRUserDefault.userReadAttConfig = dic;
        [self reloadFontLable];
    }
    if (self.block){
        self.block();
    }
}

#pragma mark -UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BRReadBgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BRReadBgCollectionViewCell" forIndexPath:indexPath];
    
    UIImage *image = [self.bgIconArray objectAtIndex:indexPath.row];
    BOOL isSelected = [[self.bgSelectedArray objectAtIndex:indexPath.row] boolValue];
    
    [cell setBackImage:image isSelected:isSelected];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    space = nil;
    BRUserDefault.readBackColorIndex = indexPath.row;
    
    [self reloadBackColor];
    if (self.block){
        self.block();
    }
}
#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bgIconArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


@end
