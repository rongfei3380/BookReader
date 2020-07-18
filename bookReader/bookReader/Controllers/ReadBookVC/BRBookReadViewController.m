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

@interface BRBookReadViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property(nonatomic, strong) BRBookPageViewController *bookPageVC;
@property(nonatomic, strong) CFButtonUpDwon *nightButton;
@property(nonatomic, strong) BRChaptersView *chaptersView;
@property(nonatomic, strong) BRBookSetingView *settingView;
@property (nonatomic,strong) UIView* brightnessView;
@property (nonatomic,assign) BOOL isFirstLoad;

@end

@implementation BRBookReadViewController


#pragma mark- init View

- (void)initialNavi
{
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.backgroundColor = CFUIColorFromRGBAInHex(0xf1f1f1, 1);
    
    UIButton* button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGSize strSize = [[self.viewModel getBookName] sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    button.frame = CGRectMake(0, 0, strSize.width + 15, 40);
    button.tintColor = CFUIColorFromRGBAInHex(0x696969, 1);
    [button setTitleColor:CFUIColorFromRGBAInHex(0x696969, 1) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navi_backbtnImage_white"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(naviLeftBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[self.viewModel getBookName] forState:UIControlStateNormal];
    

    UIBarButtonItem* left = [[UIBarButtonItem alloc] initWithCustomView:button];
    left.tintColor = CFUIColorFromRGBAInHex(0x696969, 1);
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithTitle:@"换源" style:UIBarButtonItemStyleDone target:self action:@selector(naviRightBarItemClick)];
    
    right.tintColor =CFUIColorFromRGBAInHex(0x696969, 1);
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:(UIControlStateNormal)];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:(UIControlStateSelected)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = CFUIColorFromRGBAInHex(0xf1f1f1, 1);
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)initialToolBar
{
    UIToolbar* tabBar = self.navigationController.toolbar;
    CGRect frame = CGRectMake(0.0, 0, SCREEN_WIDTH,tabBar.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = CFUIColorFromRGBAInHex(0xf1f1f1, 1);
    [tabBar insertSubview:view atIndex:0];
    UIBarButtonItem* fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    
    CFButtonUpDwon *nightButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [nightButton setTitle:@"白天" forState:UIControlStateNormal];
    [nightButton setTitle:@"黑夜" forState:UIControlStateSelected];
    [nightButton setImage:[UIImage imageNamed:@"toolbar_day"] forState:UIControlStateNormal];
    [nightButton setImage:[UIImage imageNamed:@"toolbar_night"] forState:UIControlStateSelected];
    [nightButton addTarget:self action:@selector(changeNightStyle) forControlEvents:UIControlEventTouchUpInside];
    self.nightButton = nightButton;
    
    CFButtonUpDwon *muluButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [muluButton setTitle:@"目录" forState:UIControlStateNormal];
    [muluButton setImage:[UIImage imageNamed:@"toolbar_mulu"] forState:UIControlStateNormal];
    [muluButton addTarget:self action:@selector(showMulu) forControlEvents:UIControlEventTouchUpInside];
    
    CFButtonUpDwon *setButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [setButton setTitle:@"设置" forState:UIControlStateNormal];
    [setButton setImage:[UIImage imageNamed:@"toolbar_setting"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    
    CFButtonUpDwon *readButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [readButton setTitle:@"缓存" forState:UIControlStateNormal];
    [readButton setImage:[UIImage imageNamed:@"toolbar_caching"] forState:UIControlStateNormal];
    [readButton addTarget:self action:@selector(showWait) forControlEvents:UIControlEventTouchUpInside];
    
    CFButtonUpDwon *backButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"反馈" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"toolbar_feedback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(showBackAlert) forControlEvents:UIControlEventTouchUpInside];
    self.toolbarItems = @[muluButton,fixed,nightButton,fixed,setButton,fixed,readButton,fixed,backButton];
}

- (void)initialSubViews
{
    self.view.backgroundColor = BRUserDefault.readBackColor?:CFUIColorFromRGBAInHex(0xa39e8b, 1);
    
    [self addChildViewController:self.bookPageVC];
    [self.view addSubview:_bookPageVC.view];
    
    self.chaptersView = [[BRChaptersView alloc] initWithFrame:CGRectMake(0, 0, 0, SCREEN_HEIGHT)];
    kWeakSelf(self);
    self.chaptersView.didSelectChapter = ^(NSInteger index) {
        kStrongSelf(self);
        [self.viewModel loadChapterWithIndex:index];
    };
    [self.view addSubview:self.chaptersView];
    
    self.settingView = [[BRBookSetingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 370, SCREEN_WIDTH, 330)];
    
    self.settingView.block = ^{
        kStrongSelf(self);
        [self.viewModel reloadContentViews];
        
    };
    self.settingView.sliderValueBlock = ^{
        kStrongSelf(self);
        self.brightnessView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:BRUserDefault.readBrightness];
    };
    
    [self.view addSubview:self.settingView];
    self.settingView.hidden = YES;
    
    self.brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.brightnessView.userInteractionEnabled = NO;
    self.brightnessView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:BRUserDefault.readBrightness];
    [self.view addSubview:self.brightnessView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviBarHidenWithAnimated) name:kNotifyReadContentTouchEnd object:nil];
}

#pragma mark- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initialData
{
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

- (void)showBackAlert
{
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

- (void)naviLeftBarItemClick
{
    if (![self.navigationController popViewControllerAnimated:YES]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)naviRightBarItemClick {
//    BookSourceListVC* vc = [[BookSourceListVC alloc] initWithModel:[self.viewModel getBookInfoModel]];
//    vc.block = ^{
//        [self.viewModel startInit];
//    };
//    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:navi animated:YES completion:nil];
}

- (void)showMulu
{
    if (!self.chaptersView.isShowMulu){
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.toolbarHidden = YES;
        
        self.chaptersView.currentIndex = [self.viewModel getCurrentChapterIndex];
        self.chaptersView.bookName = [self.viewModel getBookName];
        self.chaptersView.chapters = [self.viewModel getAllChapters];
    }
    
    self.settingView.hidden = YES;
    self.chaptersView.isShowMulu = !self.chaptersView.isShowMulu;
}

- (void)showSettingView
{
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

- (void)changeNaviBarHidenWithAnimated
{
    self.settingView.hidden = YES;
    if (self.navigationController.navigationBarHidden){
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.toolbarHidden = NO;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.toolbarHidden = YES;
    }
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
    
    
    [self.pageViewController setViewControllers:viewControllers
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
-(UIPageViewController *)pageViewController
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


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

@end
