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
#import "BRSitesSelectViewController.h"
#import "BRDataBaseManager.h"
#import "BRDataBaseCacheManager.h"
#import "BRChoseCacheView.h"
#import "DZMCoverController.h"
#import "BRBookUpDownPageViewController.h"

@interface BRBookReadViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, BRSitesSelectViewControllerDelegate, BRChoseCacheViewDelegate, DZMCoverControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
}

@property(nonatomic, strong) BRBookPageViewController *bookPageVC;
@property(nonatomic, strong) DZMCoverController *coverController;
@property(nonatomic, strong) BRBookUpDownPageViewController *bookUpDownPageViewController;

@property(nonatomic, strong) CFButtonUpDwon *nightButton;
@property(nonatomic, strong) CFButtonUpDwon *muluButton;
@property(nonatomic, strong) CFButtonUpDwon *setButton;
@property(nonatomic, strong) BRChaptersView *chaptersView;
@property(nonatomic, strong) BRBookSetingView *settingView;
@property (nonatomic,strong) UIView* brightnessView;
@property(nonatomic, strong) UIView *toolbarView;
@property (nonatomic, strong) NSTimer *timer;


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
    
    
    self.muluButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [self.muluButton setTitle:@"目录" forState:UIControlStateNormal];
    [self.muluButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [self.muluButton setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
    self.muluButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.muluButton setImage:[UIImage imageNamed:@"btn_mune_normal"] forState:UIControlStateNormal];
    [self.muluButton setImage:[UIImage imageNamed:@"btn_mune_selected"] forState:UIControlStateSelected];
    [self.muluButton addTarget:self action:@selector(showMulu) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:self.muluButton];
    
    CFButtonUpDwon *nightButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [nightButton setTitle:@"黑夜" forState:UIControlStateNormal];
    [nightButton setTitle:@"白天" forState:UIControlStateSelected];
    nightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [nightButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [nightButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateSelected];
    [nightButton setImage:[UIImage imageNamed:@"btn_nightread_normal"] forState:UIControlStateNormal];
    [nightButton setImage:[UIImage imageNamed:@"btn_nightread_selected"] forState:UIControlStateSelected];
    [nightButton addTarget:self action:@selector(changeNightStyle:) forControlEvents:UIControlEventTouchUpInside];
    self.nightButton = nightButton;
    if (BRUserDefault.isNightStyle){
           self.nightButton.selected = YES;
       }else{
           self.nightButton.selected = NO;
       }
    [_toolbarView addSubview:nightButton];
    
  
    
    self.setButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [self.setButton setTitle:@"设置" forState:UIControlStateNormal];
    self.setButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.setButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [self.setButton setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
    [self.setButton setImage:[UIImage imageNamed:@"btn_setting_normal"] forState:UIControlStateNormal];
    [self.setButton setImage:[UIImage imageNamed:@"btn_setting_selected"] forState:UIControlStateSelected];
    [self.setButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:self.setButton];
    
    CFButtonUpDwon *cacheButton = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [cacheButton setTitleColor:CFUIColorFromRGBAInHex(0x292F3D, 1) forState:UIControlStateNormal];
    [cacheButton setTitleColor:CFUIColorFromRGBAInHex(0xFFA317, 1) forState:UIControlStateSelected];
    [cacheButton setTitle:@"缓存" forState:UIControlStateNormal];
    cacheButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cacheButton setImage:[UIImage imageNamed:@"btn_download_normal"] forState:UIControlStateNormal];
    [cacheButton addTarget:self action:@selector(clickCacheButton:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:cacheButton];
    
    
    NSArray *masonryViewArray = @[self.muluButton, nightButton, self.setButton, cacheButton];
    
    // 实现masonry水平固定控件宽度方法
    [masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:40 leadSpacing:30 tailSpacing:30];
    
    // 设置array的垂直方向的约束
    [masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.height.mas_equalTo(40);
    }];
    _toolbarView.hidden = YES;
}

- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)initialSubViews {
    UIColor *color11 = [UIColor colorWithPatternImage:[self imageResize:[UIImage imageNamed:@"reading_bg_six"] andResizeTo:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];

    
    self.view.backgroundColor = BRUserDefault.readBackColor ? : color11;
    
    if (BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        [self addChildViewController:self.bookPageVC];
        [self.view insertSubview:_bookPageVC.view atIndex:0];
    } else {
        [self addChildViewController:self.coverController];
        [self.view insertSubview:_coverController.view atIndex:0];
    }
        
    self.chaptersView = [[BRChaptersView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height -(BOTTOM_HEIGHT))];
//    self.chaptersView.chapters = self.viewModel.getAllChapters;
    self.chaptersView.bookName = self.viewModel.getBookName;
    kWeakSelf(self);
    self.chaptersView.didSelectChapter = ^(NSInteger index) {
        kStrongSelf(self);
        self.chaptersView.hidden = YES;
        self.muluButton.selected = NO;
        [self.viewModel loadChapterWithIndex:index];
        [self changeNaviBarHidenWithAnimated];
    };
    self.chaptersView.didSelectHidden = ^{
        kStrongSelf(self);
        self.chaptersView.hidden = YES;
        self.muluButton.selected = NO;
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
    
    [self.view insertSubview:self.settingView aboveSubview:self.headView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.toolbarView.mas_top).offset(0);
        make.height.mas_equalTo(330);
    }];
    self.settingView.hidden = YES;
    
    self.brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.brightnessView.userInteractionEnabled = NO;
    self.brightnessView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:BRUserDefault.readBrightness];
    [self.view addSubview:self.brightnessView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviBarHidenWithAnimated) name:kNotifyReadContentTouchEnd object:nil];
}

- (void)createChangeSiteButton {
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"nav_yuan"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(clickChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-2);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)clickChangeBtn:(id)sender{
    BRSitesSelectViewController *vc = [[BRSitesSelectViewController alloc] init];
    vc.bookId = self.viewModel.BRBookInfoModel.bookId;
    vc.sitesArray = self.viewModel.BRBookInfoModel.sitesArray;
    vc.selectedSiteIndex = self.viewModel.BRBookInfoModel.siteIndex.integerValue;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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
    [self createChangeSiteButton];
    self.isFirstLoad = YES;
    self.headView.hidden = YES;
    self.headView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
//    用来处理息屏的代码
    
    NSDate *scheduledTime = [NSDate dateWithTimeIntervalSinceNow:120.0];

    self.timer =  [[NSTimer alloc] initWithFireDate:scheduledTime interval:120 target:self selector:@selector(idleTimerDisabledFire) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //开启定时器
    [self.timer fire];
}

- (void)viewDidAppear:(BOOL)animated{
    
    if (!self.isFirstLoad){
        [self hidenView];
        self.settingView.hidden = YES;
    }
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:120.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)initialData {
#pragma mark - 设置ViewModel的反向回调
    /* 数据加载*/
    kWeakSelf(self);
    [self.viewModel loadDataWithSuccess:^(UIViewController *currentVC) {
        kStrongSelf(self);
        kdispatch_main_sync_safe(^{
            [self loadDataSuccess:currentVC];
        });
    } Fail:^(NSError *err) {
        kStrongSelf(self);
        if (![err.domain isEqualToString:@"NSURLErrorDomain"]) {
            [self loadDataFail];
        }
    }];

    /* 章节数据开始加载时*/
    [self.viewModel startLoadData:^{
        kStrongSelf(self);
        [self showBookLoading];
    }];
    
    [self.viewModel loadChapters:^{
        kStrongSelf(self);
        [self.chaptersView reloadData];
    }];
    
    /* 用于ViewModel反向通知VC显示提示框*/
    [self.viewModel showHubWithSuccess:^(NSString *text) {
        kStrongSelf(self)
        [self hideBookLoading];
        [self showSuccessMessage:text];
    } Fail:^(NSString *text) {
        kStrongSelf(self)
        [self hideBookLoading];
        [self showErrorStatus:text];
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

/// 按数量缓存 章节
/// @param chapters 所有章节
/// @param count  章节数量 0时 代表所有章节
- (void)cacheChapters:(NSArray<BRChapter *> * _Nonnull)chapters count:(NSInteger)count {
    
    BRBookInfoModel *book = self.viewModel.BRBookInfoModel;
    __weak BRSite *site = [book.sitesArray objectAtIndex:(book.siteIndex.integerValue >= book.sitesArray.count ? book.sitesArray.count -1 : book.siteIndex.integerValue)]; // 这里需要避免 源变更导致的问题
    NSInteger currentIndex = self.viewModel.getCurrentChapterIndex;
    
    NSInteger cacheCount = count;
    
    if(currentIndex +count > chapters.count -1) {
        cacheCount = chapters.count - currentIndex;
    }
    
    if (count <= 0) {
        cacheCount = chapters.count -currentIndex;
    }
    
    if (!chapters || chapters.count == 0) {
        kWeakSelf(self)
            
       [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
           kStrongSelf(self)
           NSInteger count = chapters.count < cacheCount ? chapters.count : cacheCount;
           NSArray *cacheArray = [chapters subarrayWithRange:NSMakeRange(currentIndex, count)];
           NSMutableArray *cacheChaptersArray = [NSMutableArray array];
           for (BRChapter *chapter in cacheArray) {
               [cacheChaptersArray addObject:chapter.chapterId];
           }
        
           [self showProgressMessage:@"正在添加章节缓存"];
           [[BRDataBaseCacheManager sharedInstance] cacheChapterContentWithBook:book chapterIds:cacheChaptersArray siteId:site.siteId progress:^(NSInteger receivedCount, NSInteger expectedCount, BRCacheTask * _Nullable task) {
               kdispatch_main_sync_safe(^{
                   [self hideBookProgressMessage];
                   [self hideBookLoading];
                   [BRMessageHUD showSuccessMessage:@"已添加章节缓存" to:self.view];
               });
            } completed:^(BRCacheTask * _Nullable task, NSError * _Nullable error, BOOL finished) {
                    if (error) {
                        [self hideBookProgressMessage];
                        [self showErrorMessage:error];
                    }
                }];
           
        }];
    } else {
       [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
           NSInteger count = chapters.count < cacheCount ? chapters.count : cacheCount;
           NSArray *cacheArray = [chapters subarrayWithRange:NSMakeRange(currentIndex, count)];
           NSMutableArray *cacheChaptersArray = [NSMutableArray array];
           for (BRChapter *chapter in cacheArray) {
               [cacheChaptersArray addObject:chapter.chapterId];
           }
           [self showProgressMessage:@"正在添加章节缓存"];
           [[BRDataBaseCacheManager sharedInstance] cacheChapterContentWithBook:book chapterIds:cacheChaptersArray siteId:site.siteId progress:^(NSInteger receivedCount, NSInteger expectedCount, BRCacheTask * _Nullable task) {
                             
            } completed:^(BRCacheTask * _Nullable task, NSError * _Nullable error, BOOL finished) {
                kdispatch_main_sync_safe(^{
                    if (error ) {
                        [self hideBookProgressMessage];
                        [self showErrorMessage:error];
                    } else {
                        if (!finished) {
                            kdispatch_main_sync_safe(^{
                                [self hideBookProgressMessage];
                                [self hideBookLoading];
                                [BRMessageHUD showSuccessMessage:@"已添加章节缓存" to:self.view];
                            });
                        }
                    }
                });
            }];
            
        }];
    }
}

#pragma mark - func
- (void)clickCacheButton:(UIButton *)button {
    BRBookInfoModel *book = self.viewModel.BRBookInfoModel;
    BRSite *site = [book.sitesArray objectAtIndex:(book.siteIndex.integerValue >= book.sitesArray.count ? book.sitesArray.count -1 : book.siteIndex.integerValue)]; // 这里需要避免 源变更导致的问题
    
    [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:book.bookId siteId:site.siteId chapters:^(NSArray<BRChapter *> * _Nonnull chapters) {
            BRChoseCacheView *vc = [[BRChoseCacheView alloc] init];
            vc.delegate = self;
            vc.allChapters  = chapters;
            [vc show];
    }];
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
        [self.viewModel getNewAllChapters];// 这里获取一下 最新的目录 更新目录缓存
        self.chaptersView.chapters = [self.viewModel getAllChapters];
    }
    
    if (!self.settingView.hidden) {
        self.settingView.hidden = YES;
        self.setButton.selected = NO;
    }
  
    self.muluButton.selected = !self.muluButton.selected;
    self.settingView.hidden = YES;
    self.chaptersView.hidden = !self.chaptersView.hidden;
}

- (void)showSettingView {
    if (!self.chaptersView.hidden) {
        self.chaptersView.hidden = YES;
        self.muluButton.selected = NO;
    }
    
    self.setButton.selected = !self.setButton.selected;
    self.settingView.hidden = !self.settingView.hidden;
}

- (void)changeNightStyle:(UIButton *)button {
    BOOL isNight = BRUserDefault.isNightStyle;
    
    BRUserDefault.isNightStyle = !isNight;
    
    if (BRUserDefault.isNightStyle){
        button.selected = YES;
    }else{
        button.selected = NO;
    }
    
    
    [self.viewModel reloadContentViews];
}

- (void)changeNaviBarHidenWithAnimated {
    if (_toolbarView.hidden) {
        _toolbarView.hidden = NO;
        self.headView.hidden = NO;
    } else {
        _toolbarView.hidden = YES;
        self.headView.hidden = YES;
    }
    self.setButton.selected = NO;
    self.settingView.hidden = YES;
}

- (void)hidenView {
    if (!_toolbarView.hidden) {
        _toolbarView.hidden = YES;
        self.headView.hidden = YES;
        self.setButton.selected = NO;
        self.settingView.hidden = YES;
    }
}

- (void)hidenNaviBar{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.toolbarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

/* 章节数据加载成功*/
- (void)loadDataSuccess:(UIViewController*)currentVC {
    [self hideBookLoading];
    
    if (BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        
        if(_bookPageVC) {
            [_bookPageVC.view removeFromSuperview];
            _bookPageVC = nil;
        }
        
        if (_coverController) {
            [_coverController.view removeFromSuperview];
            _coverController = nil;
        }
        
        if (_bookUpDownPageViewController) {
            [_bookUpDownPageViewController.view removeFromSuperview];
            _bookUpDownPageViewController = nil;
        }
        
        NSArray *viewControllers = [NSArray arrayWithObject:currentVC];
        if (!_bookPageVC) {
            _bookPageVC = [[BRBookPageViewController alloc] initWithTransitionStyle:BRUserDefault.PageTransitionStyle navigationOrientation:BRUserDefault.PageNaviOrientation options:nil];
            kWeakSelf(self);
            _bookPageVC.block = ^{
                kStrongSelf(self);
                [self changeNaviBarHidenWithAnimated];
            };
            _bookPageVC.delegate = self;
            _bookPageVC.dataSource = self;
            /* 通过双面显示,解决UIPageViewController仿真翻页时背面发白的问题*/
            _bookPageVC.doubleSided = (BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl ? YES : NO);
            [self.view insertSubview:_bookPageVC.view atIndex:0];
        }
        [self.bookPageVC setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
                
        _bookPageVC.view.backgroundColor = BRUserDefault.readBackColor ? CFUIColorFromRGBAInHex(0xffffff, 1): CFUIColorFromRGBAInHex(0xa39e8b, 1);
       
        
        
    } else if (BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStyleScroll){
        
        if(_bookPageVC) {
            [_bookPageVC.view removeFromSuperview];
            _bookPageVC = nil;
        }
        
        if (_coverController) {
            [_coverController.view removeFromSuperview];
            _coverController = nil;
        }
                
        if (_bookUpDownPageViewController) {
            [_bookUpDownPageViewController.view removeFromSuperview];
            _bookUpDownPageViewController = nil;
        }
        
        if (!_coverController) {
            _coverController = [[DZMCoverController alloc] init];
            _coverController.delegate = self;
            _coverController.openAnimate = false;
            [self.view insertSubview:_coverController.view atIndex:0];
        }
        [_coverController setController:currentVC animated:YES isAbove:YES];
        
        _coverController.view.backgroundColor = BRUserDefault.readBackColor ? CFUIColorFromRGBAInHex(0xffffff, 1): CFUIColorFromRGBAInHex(0xa39e8b, 1);
        
        
    } else if (BRUserDefault.PageTransitionStyle == 2){
        
        if(_bookPageVC) {
            [_bookPageVC.view removeFromSuperview];
            _bookPageVC = nil;
        }
        
        if (_coverController) {
            [_coverController.view removeFromSuperview];
            _coverController = nil;
        }
        

        if (!_bookUpDownPageViewController) {
            _bookUpDownPageViewController = [[BRBookUpDownPageViewController alloc] init];
            _bookUpDownPageViewController.viewModel = self.viewModel;
            kWeakSelf(self);
            _bookUpDownPageViewController.block = ^{
                kStrongSelf(self);
                [self changeNaviBarHidenWithAnimated];
            };
            _bookUpDownPageViewController.tableView.backgroundColor = BRUserDefault.readBackColor ? CFUIColorFromRGBAInHex(0xffffff, 1): CFUIColorFromRGBAInHex(0xa39e8b, 1);

            
            [self.view insertSubview:_bookUpDownPageViewController.view atIndex:0];
        }
    }
    
    
    
}

/* 章节数据加载失败*/
- (void)loadDataFail {
    [self hideBookLoading];
    [self showErrorStatus:@"章节加载失败"];
    [_bookPageVC.view removeFromSuperview];
    [self changeNaviBarHidenWithAnimated];
}

- (void)idleTimerDisabledFire {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    BOOL isDouble = BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl ? YES : NO;
    [self hidenView];
    return [self.viewModel viewControllerBeforeViewController:viewController DoubleSided:isDouble];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    BOOL isDouble = BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl ? YES : NO;
    [self hidenView];
    return [self.viewModel viewControllerAfterViewController:viewController DoubleSided:isDouble];
}

#pragma mark- UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    //再次开启定时器
     [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:120.0];
}

#pragma mark- DZMCoverControllerDelegate

/**
 *  切换是否完成
 *
 *  @param coverController   coverController
 *  @param currentController 当前正在显示的控制器
 *  @param isFinish          切换是否成功
 */
- (void)coverController:(DZMCoverController * _Nonnull)coverController currentController:(UIViewController * _Nullable)currentController finish:(BOOL)isFinish {
    
}

/**
 *  将要显示的控制器
 *
 *  @param coverController   coverController
 *  @param pendingController 将要显示的控制器
 */
- (void)coverController:(DZMCoverController * _Nonnull)coverController willTransitionToPendingController:(UIViewController * _Nullable)pendingController {
    
}

/**
 *  获取上一个控制器
 *
 *  @param coverController   coverController
 *  @param currentController 当前正在显示的控制器
 *
 *  @return 返回当前显示控制器的上一个控制器
 */
- (UIViewController * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getAboveControllerWithCurrentController:(UIViewController * _Nullable)currentController {
    BOOL isDouble = BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl ? YES : NO;
    [self hidenView];
    return [self.viewModel viewControllerBeforeViewController:currentController DoubleSided:isDouble];
}

/**
 *  获取下一个控制器
 *
 *  @param coverController   coverController
 *  @param currentController 当前正在显示的控制器
 *
 *  @return 返回当前显示控制器的下一个控制器
 */
- (UIViewController * _Nullable)coverController:(DZMCoverController * _Nonnull)coverController getBelowControllerWithCurrentController:(UIViewController * _Nullable)currentController {
    BOOL isDouble = BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl ? YES : NO;
    [self hidenView];
    return [self.viewModel viewControllerAfterViewController:currentController DoubleSided:isDouble];
}

- (void)tapCoverControllerCenter:(DZMCoverController * _Nonnull)coverController {
    [self changeNaviBarHidenWithAnimated];
}

#pragma mark - lazyLoad
- (UIPageViewController *)bookPageVC {
    if (!_bookPageVC) {
        _bookPageVC = [[BRBookPageViewController alloc] initWithTransitionStyle:BRUserDefault.PageTransitionStyle navigationOrientation:BRUserDefault.PageNaviOrientation options:nil];
        
        kWeakSelf(self);
        _bookPageVC.block = ^{
            kStrongSelf(self);
            [self changeNaviBarHidenWithAnimated];
        };
        _bookPageVC.delegate = self;
        _bookPageVC.dataSource = self;
        _bookPageVC.doubleSided = BRUserDefault.PageTransitionStyle == UIPageViewControllerTransitionStylePageCurl ? YES : NO;
        [self.view insertSubview:_bookPageVC.view atIndex:0];
    }
    return _bookPageVC;
}

- (DZMCoverController *)coverController {
    if (!_coverController) {
        _coverController = [[DZMCoverController alloc] init];
        _coverController.delegate = self;
        _coverController.openAnimate = false;
        [self.view insertSubview:_coverController.view atIndex:0];
    }
    return _coverController;
}

- (BRBookUpDownPageViewController *)bookUpDownPageViewController {
    if (!_bookUpDownPageViewController) {
        _bookUpDownPageViewController = [[BRBookUpDownPageViewController alloc] init];
        _bookUpDownPageViewController.viewModel = self.viewModel;
    }
    
    return _bookUpDownPageViewController;
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
#pragma mark-BRSitesSelectViewControllerDelegate

- (void)sitesSelectViewController:(NSInteger)index {
    if(self.viewModel.BRBookInfoModel.siteIndex.intValue != index) {
        self.viewModel.BRBookInfoModel.siteIndex = [NSNumber numberWithInteger:index];
        [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.viewModel.BRBookInfoModel.bookId sites:self.viewModel.BRBookInfoModel.sitesArray curSiteIndex:self.viewModel.BRBookInfoModel.siteIndex.intValue];
        
        [self.viewModel startInit];
    }
}

- (void)sitesUpdate:(NSArray<BRSite *> *_Nonnull)sitesArray {
    self.viewModel.BRBookInfoModel.sitesArray = sitesArray;
    [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:self.viewModel.BRBookInfoModel.bookId sites:sitesArray curSiteIndex:self.viewModel.BRBookInfoModel.siteIndex.integerValue];
    [self.chaptersView reloadData];
}

#pragma mark-BRChoseCacheViewDelegate
- (void)choseCacheViewClickCacheButtonWithChapter:(NSArray *)chapters count:(NSInteger)count {
    [self cacheChapters:chapters count:count];
}


@end
