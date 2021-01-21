//
//  BRBaseViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/7.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"
#import "BRBookInfoViewController.h"
#import "BRBookInfoCollectionViewController.h"
#import <MBProgressHUD.h>
#import <YYWebImage.h>
#import <Lottie/Lottie.h>
#import "BRSearchBookViewController.h"
#import "BRHTTPSessionManager.h"

@interface BRBaseViewController () {
    UIButton *_backButton;
}

@property(nonatomic, strong, readwrite) UIView *headView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *bookLoadingView;
@property(nonatomic, strong) LOTAnimationView *loadingAnimationView;
@property(nonatomic, strong) UIImageView *animationView;

@end

@implementation BRBaseViewController

- (id)init {
    self = [super init];
    if (self) {
        self.isFirstLoad = YES;
    }
    return self;
}


- (void)loadView {
    [super loadView];
    self.view.backgroundColor = CFUIColorFromRGBAInHex(0xFFFFFF, 1);
    
    if (_enableModule & BaseViewEnableModuleHeadView) {
        _headView = [[UIView alloc] init];
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(0);
            make.height.mas_offset(44+kStatusBarHeight());
        }];
    }
    
    if (_enableModule & BaseViewEnableModuleBackBtn) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [_headView insertSubview:_backButton atIndex:999];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(5);
            make.bottom.mas_offset(-2);
            make.size.width.mas_offset(40);
            make.size.height.mas_offset(40);
        }];
    }
    
    if (_enableModule & BaseViewEnableModuleTitle) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = _headTitle;
        [_headView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-7);
            make.centerX.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH -100);
            make.height.mas_offset(30);
        }];
    }
    
    if (_enableModule & BaseViewEnableModuleSearch) {
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(clickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:searchBtn];
        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.mas_offset(-2);
            make.right.mas_equalTo(self.headView).offset(-5);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isFirstLoad = NO;
}

- (void)dealloc {
    [[BRHTTPSessionManager sharedManager].operationQueue cancelAllOperations];
}

#pragma mark- button methods

- (void)clickBackButton:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSearchBtn:(UIButton *)sender {
    BRSearchBookViewController *vc = [[BRSearchBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- public

- (void)goBookInfoViewWIthBook:(BRBookInfoModel *)book {
    BRBookInfoCollectionViewController *vc = [[BRBookInfoCollectionViewController alloc] init];
    vc.bookInfo = book;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)fetchEmptyImage {
    return self.emptyImg;
}

- (NSString *)fetchEmptyString {
    return self.emptyString;
}

#pragma mark- Cache

///  缓存数据
/// @param records 需要缓存的数据
- (void)cacheRecords:(NSArray *)records key:(NSString *)key {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    
    YYDiskCache *recordsCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:NSStringFromClass([self class])] inlineThreshold:0];
   
    
    NSString *cacheKey = nil;
   if (key) {
       cacheKey =[NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
   } else {
       cacheKey = NSStringFromClass([self class]);
   }
   
//   [recordsCache removeObjectForKey:cacheKey withBlock:^(NSString * _Nonnull key) {
//
//   }];
    [recordsCache setObject:records forKey:cacheKey];
}

/// 获取缓存的数据
- (NSArray *)getCacheRecordsWithKey:(NSString *)key {
        
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
        
    YYDiskCache *recordsCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:NSStringFromClass([self class])] inlineThreshold:0];
    
//    recordsCache.customArchiveBlock   = ^(id object) {
//        return object;
//    };
//    recordsCache.customUnarchiveBlock = ^(NSData *object) {
//        return object;
//    };

    
    NSString *cacheKey = nil;
    if (key) {
        cacheKey =[NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
    } else {
        cacheKey = NSStringFromClass([self class]);
    }
    
    
    id object = (id)[recordsCache objectForKey:cacheKey];
    
    NSMutableArray *array = [NSMutableArray array];
    if (object) {
        [array addObjectsFromArray:object];
    }
    return array;

}


#pragma mark- ProgressHUD

- (NSString *)generateErrorMessage:(NSError *)error {
    NSString *msg = error.localizedDescription;
    return msg;
}

- (void)showBookLoading {
    [self hideBookLoading];
    
    _loadingAnimationView = [LOTAnimationView animationNamed:@"bookLoading.json" inBundle:[NSBundle mainBundle]];
    _loadingAnimationView.frame = CGRectMake(20, 20, 25, 25);
    _loadingAnimationView.loopAnimation = YES;
    
    
    _bookLoadingView = [[UIView alloc] init];
    _bookLoadingView.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0.8);
    _bookLoadingView.clipsToBounds = YES;
    _bookLoadingView.layer.cornerRadius = 5.f;
    [_bookLoadingView addSubview:_loadingAnimationView];
    [_loadingAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_loadingAnimationView play];
    [self.view addSubview:_bookLoadingView];
    
    [_bookLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *contenLabel = [[UILabel alloc] init];
    contenLabel.text = @"正在读取内容...";
    contenLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    contenLabel.font = [UIFont systemFontOfSize:20];
    [_bookLoadingView addSubview:contenLabel];
    [contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_loadingAnimationView.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)hideBookLoading {
    if (_bookLoadingView && _bookLoadingView.superview) {
        
        [_loadingAnimationView stop];
        [_loadingAnimationView removeFromSuperview];
        _loadingAnimationView = nil;
        
        [_bookLoadingView removeFromSuperview];
        _bookLoadingView = nil;
    }
}

- (void)showSuccessMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     UIImage *image = [[UIImage imageNamed:@"success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     
     UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
     
     hud.customView = imageView;
     hud.mode = MBProgressHUDModeCustomView;
     
    hud.label.text = message;
     
     [hud hideAnimated:YES afterDelay:3];
}


- (void)showErrorMessage:(NSError *)error {
    [self showErrorMessage:error withDelay:3];
}

- (void)showErrorStatus:(NSString *)errorStr {
    NSError *error = [NSError errorWithDomain:@"com.chengfeir.bookread" code:0 userInfo:[NSDictionary dictionaryWithObject:errorStr forKey:@"NSLocalizedDescription"]];
    [self showErrorMessage:error];
}

- (void)showErrorMessage:(NSError *)error withDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.color = CFUIColorFromRGBAInHex(0x000000, 1);
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.label.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    hud.label.text = [self generateErrorMessage:error];
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)showProgressMessage:(NSString *)message {
    [self hideBookLoading];
    
    _bookLoadingView = [[UIView alloc] init];
    _bookLoadingView.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0.6);
    _bookLoadingView.clipsToBounds = YES;
    _bookLoadingView.layer.cornerRadius = 12.f;
    [self.view addSubview:_bookLoadingView];
    [_bookLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(180);
    }];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<= 146; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_bookLoading_%d", i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    
    _animationView = [[UIImageView alloc] init];
    _animationView.animationImages = images;
    _animationView.animationRepeatCount = 1000;
    [_animationView startAnimating];
     [_bookLoadingView addSubview:_animationView];
     [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(0);
         make.top.mas_offset(20);
         make.size.mas_equalTo(CGSizeMake(50, 30));
     }];
    [_animationView startAnimating];
    
    UILabel *contenLabel = [[UILabel alloc] init];
    contenLabel.text = message;
    contenLabel.textAlignment = NSTextAlignmentCenter;
    contenLabel.textColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    contenLabel.font = [UIFont systemFontOfSize:14];
    [_bookLoadingView addSubview:contenLabel];
    [contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_animationView.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)showProgressMessage:(NSString *)message closable:(BOOL)closable {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Set some text to show the initial status.
    hud.label.text = message;
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);

    [self hideProgressMessage];
}

- (void)hideProgressMessage {
    if (_bookLoadingView && _bookLoadingView.superview) {

           [_animationView stopAnimating];
           [_animationView removeFromSuperview];
           _animationView = nil;

           [_bookLoadingView removeFromSuperview];
           _bookLoadingView = nil;
       }
}


#pragma mark- setter

- (void)setHeadTitle:(NSString *)headTitle {
    _headTitle = headTitle;
    _titleLabel.text = headTitle;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
