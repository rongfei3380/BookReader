//
//  BRTabBarViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/8.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRTabBarViewController.h"
#import "BRCategoryViewController.h"
#import "BRBookshelfViewController.h"
#import "BRRankBooksViewController.h"
#import "BRMineViewController.h"
#import "BRCategoryBooksViewController.h"
#import "BRAgreementView.h"
#import "GVUserDefaults+BRUserDefaults.h"
#import "BRWebviewViewController.h"

@interface BRTabBarViewController ()<BRAgreementViewDelegate>

@end

@implementation BRTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置tabBar的背景颜色
    self.view.backgroundColor = CFUIColorFromRGBAInHex(0xFFFFFF, 1);
    self.tabBar.barTintColor = CFUIColorFromRGBAInHex(0xF9F9F9, 1);
    //2.字体颜色
    self.tabBar.tintColor = [UIColor colorWithRed:41/255.0 green:47/255.0 blue:61/255.0 alpha:1.0];
    //3.添加所有控制器
    [self addSubViewController];
    
    self.navigationController.delegate = self;
    
    
    if (!BRUserDefault.isAgreemented) {
        BRAgreementView *view = [[BRAgreementView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.delegate = self;
        [self.view addSubview:view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark 添加所有控制器
- (void)addSubViewController
{
    [self addChildViewControllerWithClassname:@"BRBookshelfViewController" imagename:@"tab_bookshelf" title:@"书架"];
    [self addChildViewControllerWithClassname:@"BRRankBooksViewController" imagename:@"tab_ranking" title:@"排行"];
    [self addChildViewControllerWithClassname:@"BRCategoryBooksViewController" imagename:@"tab_classification" title:@"分类"];
    [self addChildViewControllerWithClassname:@"BRMineViewController" imagename:@"tab_profile" title:@"我的"];
}
 
#pragma mrak 添加子控制器
- (void)addChildViewControllerWithClassname:(NSString *)classname
                                  imagename:(NSString *)imagename
                                      title:(NSString *)title {
    
    UIViewController *vc = [[NSClassFromString(classname) alloc] init];
    vc.title = title;
    vc.tabBarItem.title = title;
    NSString *selectedImg = [NSString stringWithFormat:@"%@_sel", imagename];
    vc.tabBarItem.image = [UIImage imageNamed:imagename];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:vc];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


#pragma mark- BRAgreementViewDelegate
- (void)agreementViewDelegateAgreementViewDissmiss:(UIView *)view {
    if (view.superview) {
        BRUserDefault.isAgreemented = YES;
        [view removeFromSuperview];
    }
}

- (void)agreementViewDelegateClickLink:(NSURL *)url {
    NSString *scheme = url.scheme;
    NSString *host = url.host;
    NSString *path = url.path;
        
    if ([host isEqualToString:@"webView"]) {
        if ([path isEqualToString:@"/yonghuxieyi"]) {
            BRWebviewViewController *webVC = [[BRWebviewViewController alloc] init];
            webVC.loadHtmlName = @"yonghuxieyi";
            webVC.headTitle = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if ([path isEqualToString:@"/yinsizhengce"]) {
            BRWebviewViewController *webVC = [[BRWebviewViewController alloc] init];
            webVC.loadHtmlName = @"yinsizhengce";
            webVC.headTitle = @"隐私政策";
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }

}


@end
