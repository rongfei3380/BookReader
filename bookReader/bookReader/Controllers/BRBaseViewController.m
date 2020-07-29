//
//  BRBaseViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/7.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"
#import "BRBookInfoViewController.h"
#import <MBProgressHUD.h>
#import <YYWebImage.h>


@interface BRBaseViewController () {
    UIButton *_backButton;
}

@property(nonatomic, strong, readwrite) UIView *headView;
@property(nonatomic, strong) UILabel *titleLabel;

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
            make.top.mas_offset(kStatusBarHeight());
            make.height.mas_offset(44);
        }];
    }
    
    if (_enableModule & BaseViewEnableModuleBackBtn) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [_headView insertSubview:_backButton atIndex:999];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(5);
            make.centerY.mas_offset(0);
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
            make.centerY.mas_offset(0);
            make.centerX.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH -100);
            make.height.mas_offset(30);
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

#pragma mark- button methods

- (void)clickBackButton:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- public

- (void)goBookInfoViewWIthBook:(BRBookInfoModel *)book {
    BRBookInfoViewController *vc = [[BRBookInfoViewController alloc] init];
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
    
    YYDiskCache *recordsCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"RecordsCache"]];

    NSString *cacheKey = nil;
   if (key) {
       cacheKey =[NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
   } else {
       cacheKey = NSStringFromClass([self class]);
   }
   
   [recordsCache removeObjectForKey:cacheKey withBlock:^(NSString * _Nonnull key) {
       
   }];
    

    [recordsCache setObject:records forKey:cacheKey withBlock:^{
            
    }];

    

}

/// 获取缓存的数据
- (NSArray *)getCacheRecordsWithKey:(NSString *)key {
    
    
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    YYDiskCache *recordsCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"RecordsCache"]];

    
    NSString *cacheKey = nil;
    if (key) {
        cacheKey =[NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
    } else {
        cacheKey = NSStringFromClass([self class]);
    }
    [recordsCache objectForKey:cacheKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nullable object) {
        
    }];
    
    NSArray *array =  [recordsCache objectForKey:cacheKey];
    return array;

}


#pragma mark- ProgressHUD

- (NSString *)generateErrorMessage:(NSError *)error {
    NSString *msg = error.localizedDescription;
    return msg;
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
       UIImage *image = [[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
       
       UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
       
       hud.customView = imageView;
       hud.mode = MBProgressHUDModeCustomView;
       
       hud.label.text = [self generateErrorMessage:error];
       
       [hud hideAnimated:YES afterDelay:delay];
}

- (void)showProgressMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set some text to show the initial status.
    hud.label.text = message;
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
//        [self doSomeWorkWithMixedProgress:hud];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
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
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:3.f];
    });
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
