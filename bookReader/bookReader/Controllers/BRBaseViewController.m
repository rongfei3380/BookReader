//
//  BRBaseViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/7.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"
#import "BRBookInfoViewController.h"

@interface BRBaseViewController () {
    UIButton *_backButton;
}

@property(nonatomic, strong, readwrite) UIView *headView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation BRBaseViewController


- (void)loadView {
    [super loadView];
    self.view.backgroundColor = CFUIColorFromRGBAInHex(0xFFFFFF, 1);
    
    if (_enableModule & BaseViewEnableModuleHeadView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight(), SCREEN_WIDTH, 49)];
        [self.view addSubview:_headView];
    }
    
    if (_enableModule & BaseViewEnableModuleBackBtn) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_backButton];
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
