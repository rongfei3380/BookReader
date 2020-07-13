//
//  BRCategoryViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRCategoryViewController.h"
#import "BRCategoryBooksViewController.h"
#import "BRBookCategory.h"

@interface BRCategoryViewController () {
    BRCategoryBooksViewController *_maleVC;
    BRCategoryBooksViewController *_femaleVC;
}

@end

@implementation BRCategoryViewController


#pragma mark- private

- (void)setupContentView {
    ZJContentView *content = [[ZJContentView alloc] initWithFrame:CGRectMake(0.0, kStatusBarHeight()+49, self.view.bounds.size.width, self.view.bounds.size.height -(kStatusBarHeight()+49)) segmentView:nil parentViewController:self delegate:self];
    self.contentView = content;
    [self.view addSubview:self.contentView];
}

- (void)clickTabBtn:(UIButton *)sender {
    int tag = sender.tag % 1000;
    _selectedButton.selected = NO;
    sender.selected = YES;
    _selectedButton = sender;
    
    [self setSelectedIndex:tag animated:YES];
}


- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    _selectedIndex = selectedIndex;
    [self.contentView setContentOffSet:CGPointMake(SCREEN_WIDTH *_selectedIndex, 0) animated:animated];
}


- (NSArray <BRBaseViewController *>*)setupChildVc {
    _maleVC = [[BRCategoryBooksViewController alloc] init];
    _femaleVC = [[BRCategoryBooksViewController alloc] init];
    
    return [NSArray arrayWithObjects:_maleVC,_femaleVC, nil];
}


- (void)createVCSwitchBtns {

    CGFloat buttonWidth = 90;
    CGFloat buttonHeight = 44;
    
    CGFloat vSpace = (SCREEN_WIDTH - 49 * 2 - buttonWidth * 2) / 3.0f;
    
    
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(44 + 5 + vSpace, 0, buttonWidth, buttonHeight);
    [firstBtn setTitle:@"男生" forState:UIControlStateNormal];
    [firstBtn setTitleColor:CFUIColorFromRGBAInHex(0x666666, 1) forState:UIControlStateNormal];
    [firstBtn setTitleColor:CFUIColorFromRGBAInHex(0x333333, 1) forState:UIControlStateSelected];
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    firstBtn.tag = 1000;
    firstBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [firstBtn addTarget:self action:@selector(clickTabBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:firstBtn];
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(CGRectGetMaxX(firstBtn.frame) + vSpace, 0, buttonWidth, buttonHeight);
    [secondBtn setTitle:@"女生" forState:UIControlStateNormal];
    [secondBtn setTitleColor:CFUIColorFromRGBAInHex(0x666666, 1) forState:UIControlStateNormal];
    [secondBtn setTitleColor:CFUIColorFromRGBAInHex(0x333333, 1) forState:UIControlStateSelected];
    secondBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    secondBtn.tag = 1000 +1;
    [secondBtn addTarget:self action:@selector(clickTabBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:secondBtn];
}

#pragma mark- API

- (void)initAllCatogery {
    
    [BRBookCategory getBookCategorySucess:^(NSArray * _Nonnull maleCategoryes, NSArray * _Nonnull famaleCategory) {
        self->_maleVC.categoryArray = maleCategoryes;
        self->_femaleVC.categoryArray = famaleCategory;
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark- super

- (id)init {
    if (self = [super init]) {
        self.enableModule = BaseViewEnableModuleHeadView;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.childVcs = [self setupChildVc];
    [self setupContentView];
    [self createVCSwitchBtns];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initAllCatogery];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark- ZJScrollPageViewChildVcDelegate

- (NSInteger)numberOfChildViewControllers {
    return self.childVcs.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(BRBaseViewController *)reuseViewController forIndex:(NSInteger)index {
    BRBaseViewController<ZJScrollPageViewChildVcDelegate> *childVc = (BRBaseViewController *)reuseViewController;
    if (!childVc) {
        BRBaseViewController *vc = [self.childVcs objectAtIndex:index];
        childVc = vc;
    }
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    _selectedIndex = index;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    _selectedButton.selected = NO;
//    UIButton *selected = (UIButton *)[_headView viewWithTag:1000 +index];
//    _selectedButton = selected;
//    _selectedButton.selected = YES;
}

@end
