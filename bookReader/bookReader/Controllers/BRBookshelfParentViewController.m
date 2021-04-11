//
//  BRBookshelfParentViewController.m
//  bookReader
//
//  Created by chengfei on 2021/4/10.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookshelfParentViewController.h"
#import "ZJScrollPageView.h"
#import "BRHistoryBooksViewController.h"
#import "BRBookshelfViewController.h"
#import "FTPopOverMenu.h"
#import "GVUserDefaults+BRUserDefaults.h"

@interface BRBookshelfParentViewController ()<ZJScrollPageViewDelegate> {
    BRBaseViewController *_currentViewController;
}

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *vcArray;

@end

@implementation BRBookshelfParentViewController

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.headView.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, kStatusBarHeight(), 100, 49);
    label.numberOfLines = 0;
    label.text = @"书架";
    [self.headView addSubview:label];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"书架" attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size:24], NSForegroundColorAttributeName: CFUIColorFromRGBAInHex(0x161C2C, 1)}];

    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-5);
    }];
    
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.scrollLineHeight = 3.f;
    style.titleMargin = 15;
    style.normalTitleColor = CFUIColorFromRGBAInHex(0x9196AA, 1);
    style.selectedTitleColor = CFUIColorFromRGBAInHex(0x161C2C, 1);
    style.scrollLineColor = CFUIColorFromRGBAInHex(0x4C8BFF, 1);
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    
    self.titles = @[@"我的书籍",
                    @"浏览历史",
                    ];
    
    BRBookshelfViewController *shelfVC = [[BRBookshelfViewController alloc] init];
    BRHistoryBooksViewController *historyVC = [[BRHistoryBooksViewController alloc] init];
    
    self.vcArray = @[shelfVC, historyVC];
    
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight() +49, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.headView.frame)) segmentStyle:style titles:self.titles parentViewController:self delegate:self];

    [self.view addSubview:scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return 2;
}


- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [self.vcArray objectAtIndex:index];
        childVc.title = [self.titles objectAtIndex:index];
    }
    return childVc;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    _currentViewController = childViewController;
}

#pragma mark-

-(void)clickMoreBtn:(UIButton *)button {
    
    if (_currentViewController == [self.vcArray objectAtIndex:0]) {
        NSArray *menuNameArray = @[@"书籍管理", (BRUserDefault.isShelfStyle ? @"列表模式"  : @"书架模式")];
        NSArray *menuImageNameArray = @[@"ico_bookshelf_menu",@"icon_bookshelf_menu"];

        FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
        config.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        config.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        config.borderColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        config.separatorColor = [UIColor clearColor];
        config.shadowColor = CFUIColorFromRGBAInHex(0x000000, 1);
        config.borderWidth = 0.5f;
        
        config.borderColor = UIColor.whiteColor;
        kWeakSelf(self)
        [FTPopOverMenu showForSender:button
                       withMenuArray:menuNameArray
                          imageArray:menuImageNameArray
                       configuration:config
                           doneBlock:^(NSInteger selectedIndex) {
            BRBookshelfViewController *shelfVC = (BRBookshelfViewController *)[self.vcArray objectAtIndex:0];

            if (selectedIndex == 0) {
                [shelfVC gotoBooksManager];
            } else if (selectedIndex == 1) {
                shelfVC.isShelf = !shelfVC.isShelf;
            }
        } dismissBlock:^{
                               
        }];
    } else if (_currentViewController == [self.vcArray objectAtIndex:1]) {
        NSArray *menuNameArray = @[@"清空浏览"];
        NSArray *menuImageNameArray = @[@"ico_bookshelf_menu"];

        FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
        config.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        config.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        config.borderColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        config.separatorColor = [UIColor clearColor];
        config.shadowColor = CFUIColorFromRGBAInHex(0x000000, 1);
        config.borderWidth = 0.5f;
        
        config.borderColor = UIColor.whiteColor;
        kWeakSelf(self)
        [FTPopOverMenu showForSender:button
                       withMenuArray:menuNameArray
                          imageArray:menuImageNameArray
                       configuration:config
                           doneBlock:^(NSInteger selectedIndex) {
            kStrongSelf(self)
            BRHistoryBooksViewController *historyVC = (BRHistoryBooksViewController *)_currentViewController;
            if (selectedIndex == 0) {
                [historyVC deleteHistoryBooksInfo]; 
            }
                               
                               
        } dismissBlock:^{
                               
        }];
    }
    
   
}

@end
