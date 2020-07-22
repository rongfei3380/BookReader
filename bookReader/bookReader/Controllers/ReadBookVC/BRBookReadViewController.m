//
//  BRBookReadViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookReadViewController.h"
#import "CFButtonUpDwon.h"
#import "BRChaptersView.h"
#import "BRBookSetingView.h"
#import "BRBookPageViewController.h"
#import "CFCustomMacros.h"
#import "GVUserDefaults+BRUserDefaults.h"
#import <Masonry.h>
#import "BRNotificationMacros.h"

@interface BRBookReadViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property(nonatomic, strong) BRBookPageViewController *bookPageVC;
@property(nonatomic, strong) CFButtonUpDwon *nightButton;
@property(nonatomic, strong) BRChaptersView *chaptersView;
@property(nonatomic, strong) BRBookSetingView *settingView;
@property (nonatomic,strong) UIView* brightnessView;
@property (nonatomic,assign) BOOL isFirstLoad;
@property(nonatomic, strong) UIView *toolbarView;

@end

@implementation BRBookReadViewController


#pragma mark- init View

- (void)initialToolBar {
    
    
    _toolbarView = [[UIView alloc] init];
    _toolbarView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    _toolbarView.layer.borderColor = CFUIColorFromRGBAInHex(0xEEEEEE, 1).CGColor;
    _toolbarView.layer.borderWidth = 0.5;
    [self.view addSubview:_toolbarView];
    [_toolbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BOTTOM_HEIGHT));
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    
    CFButtonUpDwon *muluButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [muluButton setTitle:@"目录" forState:UIControlStateNormal];
    [muluButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    muluButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [muluButton setImage:[UIImage imageNamed:@"btn_mune_normal"] forState:UIControlStateNormal];
    [muluButton setImage:[UIImage imageNamed:@"btn_mune_selected"] forState:UIControlStateSelected];
    [muluButton addTarget:self action:@selector(showMulu) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:muluButton];
    
    CFButtonUpDwon *nightButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [nightButton setTitle:@"白天" forState:UIControlStateNormal];
    [nightButton setTitle:@"黑夜" forState:UIControlStateSelected];
    nightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [nightButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [nightButton setImage:[UIImage imageNamed:@"btn_nightread_normal"] forState:UIControlStateNormal];
//    [nightButton setImage:[UIImage imageNamed:@"btn_mune_selected"] forState:UIControlStateSelected];
    [nightButton addTarget:self action:@selector(changeNightStyle) forControlEvents:UIControlEventTouchUpInside];
    self.nightButton = nightButton;
    [_toolbarView addSubview:nightButton];
    
  
    
    CFButtonUpDwon *setButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [setButton setTitle:@"设置" forState:UIControlStateNormal];
    setButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [setButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [setButton setImage:[UIImage imageNamed:@"btn_setting_normal"] forState:UIControlStateNormal];
//    [setButton setImage:[UIImage imageNamed:@"btn_setting_normal"] forState:UIControlStateSelected];
    [setButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:setButton];
    
    CFButtonUpDwon *readButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [readButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [readButton setTitle:@"缓存" forState:UIControlStateNormal];
    readButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [readButton setImage:[UIImage imageNamed:@"btn_download_normal"] forState:UIControlStateNormal];
    [readButton addTarget:self action:@selector(showWait) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:readButton];
    
    
    NSArray *masonryViewArray = @[muluButton, nightButton, setButton, readButton];
    
    // 实现masonry水平固定控件宽度方法
    [masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:40 leadSpacing:30 tailSpacing:30];
    
    // 设置array的垂直方向的约束
    [masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)initialSubViews {
    self.view.backgroundColor = BRUserDefault.readBackColor?:CFUIColorFromRGBAInHex(0xa39e8b, 1);
    
    [self addChildViewController:self.bookPageVC];
    [self.view addSubview:_bookPageVC.view];
    
    self.chaptersView = [[BRChaptersView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight() +100, SCREEN_WIDTH, SCREEN_HEIGHT -(kStatusBarHeight() +100))];
    self.chaptersView.chapters = self.viewModel.getAllChapters;
    self.chaptersView.bookName = self.viewModel.getBookName;
    kWeakSelf(self);
    self.chaptersView.didSelectChapter = ^(NSInteger index) {
        kStrongSelf(self);
        self.chaptersView.hidden = YES;
        [self.viewModel loadChapterWithIndex:index];
    };
    [self.view addSubview:self.chaptersView];
    self.chaptersView.hidden = YES;
    
    self.settingView = [[BRBookSetingView alloc] init];
    
    self.settingView.block = ^{
        kStrongSelf(self);
        [self.viewModel reloadContentViews];
        
    };
    self.settingView.sliderValueBlock = ^{
        kStrongSelf(self);
        self.brightnessView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:BRUserDefault.readBrightness];
    };
    
    [self.view addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.toolbarView.mas_top).offset(0);
        make.height.mas_equalTo(300);
    }];
    self.settingView.hidden = YES;
    
    self.brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.brightnessView.userInteractionEnabled = NO;
    self.brightnessView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:BRUserDefault.readBrightness];
    [self.view addSubview:self.brightnessView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviBarHidenWithAnimated) name:kNotifyReadContentTouchEnd object:nil];
}

#pragma mark- Life Cycle

- (id)init {
    if ([self superclass]) {
        self.enableModule |= BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   [self initialToolBar];
   [self initialSubViews];
   [self initialSubViewConstraints];
   [self initialData];
    self.isFirstLoad = YES;
}

- (void)initialData {
#pragma mark - 设置ViewModel的反向回调
    /* 数据加载*/
    kWeakSelf(self);
    [self.viewModel loadDataWithSuccess:^(UIViewController *currentVC) {
        kStrongSelf(self);
        [self loadDataSuccess:currentVC];
    } Fail:^(NSError *err) {
        kStrongSelf(self);
        [self loadDataFail];
    }];
    
    /* 章节数据开始加载时*/
    [self.viewModel startLoadData:^{
        kStrongSelf(self);
//        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showMessage:@"加载中" toView:self.view delay:0.15];
    }];
    
    /* 用于ViewModel反向通知VC显示提示框*/
    [self.viewModel showHubWithSuccess:^(NSString *text) {
//        [MBProgressHUD showSuccess:text toView:self.view];
    } Fail:^(NSString *text) {
//        [MBProgressHUD showError:text toView:self.view];
    }];
    
    /* 通知VM,开始获取数据*/
    [self.viewModel startInit];
    if (self.index > 0) {
        [self.viewModel loadChapterWithIndex:self.index];
    }
}

- (void)initialSubViewConstraints {
    [_bookPageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}

#pragma mark - func
- (void)showWait {
//    [MBProgressHUD showSuccess:@"暂未完成" toView:self.view];
}

- (void)showBackAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"功能" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除当前章节缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel deleteChapterSave];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除书本章节缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel deleteBookChapterSave];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showMulu {
    if (self.chaptersView.hidden){
        self.chaptersView.currentIndex = [self.viewModel getCurrentChapterIndex];
        self.chaptersView.bookName = [self.viewModel getBookName];
        self.chaptersView.chapters = [self.viewModel getAllChapters];
    }
  
    
    self.settingView.hidden = YES;
    self.chaptersView.hidden = !self.chaptersView.hidden;
}

- (void)showSettingView {
    self.settingView.hidden = !self.settingView.hidden;
}

- (void)changeNightStyle
{
    BOOL isNight = BRUserDefault.isNightStyle;
    
//    if (isNight){
//        [self.nightView changeImageName:@"toolbar_night" Title:@"夜间"];
//    }else{
//        [self.nightView changeImageName:@"toolbar_day" Title:@"白天"];
//    }
    
    BRUserDefault.isNightStyle = !isNight;
    [self.viewModel reloadContentViews];
}

- (void)changeNaviBarHidenWithAnimated {
    if (_toolbarView.hidden) {
        _toolbarView.hidden = NO;
    } else {
        _toolbarView.hidden = YES;
    }
    self.settingView.hidden = YES;
}

- (void)hidenNaviBar
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.toolbarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

/* 章节数据加载成功*/
- (void)loadDataSuccess:(UIViewController*)currentVC
{
//    [MBProgressHUD hideHUDForView:self.view];
    
    NSArray *viewControllers = [NSArray arrayWithObject:currentVC];
    
    [_bookPageVC.view removeFromSuperview];
    _bookPageVC = [[BRBookPageViewController alloc] initWithTransitionStyle:BRUserDefault.PageTransitionStyle navigationOrientation:BRUserDefault.PageNaviOrientation options:nil];
    
    kWeakSelf(self);
    _bookPageVC.block = ^{
        kStrongSelf(self);
        [self changeNaviBarHidenWithAnimated];
    };
    _bookPageVC.delegate = self;
    _bookPageVC.dataSource = self;
    /* 通过双面显示,解决UIPageViewController仿真翻页时背面发白的问题*/
    _bookPageVC.doubleSided = BRUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
    
    _bookPageVC.view.backgroundColor = BRUserDefault.readBackColor?:CFUIColorFromRGBAInHex(0xa39e8b, 1);
    
    
    [self.bookPageVC setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
    
    [self.view insertSubview:_bookPageVC.view atIndex:0];
}

/* 章节数据加载失败*/
- (void)loadDataFail {
//    [MBProgressHUD hideHUDForView:self.view];
//    [MBProgressHUD showError:@"章节加载失败" toView:self.view];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    BOOL isDouble = BRUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
    return [self.viewModel viewControllerBeforeViewController:viewController DoubleSided:isDouble];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    BOOL isDouble = BRUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
    return [self.viewModel viewControllerAfterViewController:viewController DoubleSided:isDouble];
}

#pragma mark - lazyLoad
-(UIPageViewController *)bookPageVC
{
    if (!_bookPageVC) {
        _bookPageVC = [[BRBookPageViewController  alloc] initWithTransitionStyle:BRUserDefault.PageTransitionStyle navigationOrientation:BRUserDefault.PageNaviOrientation options:nil];
        
        kWeakSelf(self);
        _bookPageVC.block = ^{
            kStrongSelf(self);
            [self changeNaviBarHidenWithAnimated];
        };
        _bookPageVC.delegate = self;
        _bookPageVC.dataSource = self;
        _bookPageVC.doubleSided = BRUserDefault.PageTransitionStyle==UIPageViewControllerTransitionStylePageCurl?YES:NO;
        [self.view addSubview:_bookPageVC.view];
    }
    return _bookPageVC;
}


//-(UIStatusBarStyle)preferredStatusBarStyle{
//
//    return UIStatusBarStyleLightContent;
//}
//
//- (BOOL)prefersStatusBarHidden
//{
//    return self.navigationController.navigationBarHidden;
//}

@end
