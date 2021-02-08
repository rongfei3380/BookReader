//
//  BRMineViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRMineViewController.h"
#import "BRSettingTableViewCell.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import "BRHistoryBooksViewController.h"
#import "BRAboutSoftViewController.h"
#import "BRWebviewViewController.h"
#import "BRSettingViewController.h"
#import <StoreKit/StoreKit.h>
#import "BRBookCacheViewController.h"
#import "CFAltUtils.h"

static NSString * const kAppKey = @"31185069";
static NSString * const kAppSecret = @"cc5b1c1bfd72ab42519d341c40849ebe";

@interface BRMineViewController () {
    NSArray *_section0Array;
    NSArray *_section1Array;
    
    YWFeedbackKit *_feedbackKitt;
}

@end

@implementation BRMineViewController

- (id)init {
    self = [super init];
    if (self) {
         _feedbackKitt = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    UIImageView *tableHeadView = [[UIImageView alloc] init];
    tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 198);
    tableHeadView.image = [UIImage imageNamed:@"img_bg_profile"];
    
    UIImageView *avaterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_avatar"]];
    [tableHeadView addSubview:avaterImg];
    [avaterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(22);
        make.centerY.mas_offset(kStatusBarHeight()/2.f);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"书友";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    [tableHeadView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(avaterImg.mas_centerY).mas_offset(0);
        make.left.mas_equalTo(avaterImg.mas_right).mas_offset(10);
        make.right.mas_offset(-22);
        make.height.mas_offset(20);
    }];
    
    self.tableView.tableHeaderView = tableHeadView;
    self.tableView.contentInset = UIEdgeInsetsMake(kStatusBarHeight()*(-1), 0, 0, 0);
}

- (void)openFeedbackViewController {
    //  初始化方式,或者参考下方的`- (YWFeedbackKit *)feedbackKit`方法。
    //  self.feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    
    /** 设置App自定义扩展反馈数据 */
    _feedbackKitt.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"登陆->关于->反馈",
                                 @"userid":@"yourid",
                                 @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
    
    __weak typeof(self) weakSelf = self;
    [_feedbackKitt makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            [self showErrorStatus:title];
//            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
//                                                           description:nil
//                                                                  type:TWMessageBarMessageTypeError];
        }
    }];
    
//    /** 使用自定义的方式抛出error */
//    [_feedbackKitt setYWFeedbackViewControllerErrorBlock:^(YWFeedbackViewController *viewController, NSError *error) {
//        NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
////        [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
////                                                       description:[NSString stringWithFormat:@"%ld", error.code]
////                                                              type:TWMessageBarMessageTypeError];
//    }];
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external&jump_from=webapi", [CFAltUtils QQGroupUin],[CFAltUtils QQGroupUin]];
        NSURL *url = [NSURL URLWithString:urlStr];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
            return YES;
        }
        else return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _section0Array = @[
        @{@"icon":@"profile_list_history", @"title":@"浏览历史"},
        @{@"icon":@"profile_list_share", @"title": @"分享给朋友"}
    ];
    
    _section1Array = @[
        @{@"icon":@"profile_list_praise", @"title":@"给我好评"},
        @{@"icon":@"profile_list_aboult", @"title":@"关于软件"},
        @{@"icon":@"btn_detail_download", @"title":@"小说缓存"},
        @{@"icon":@"profile_list_shen", @"title":@"免责声明"},
        @{@"icon":@"profile_list_helping", @"title":@"意见反馈"},
        @{@"icon":@"profile_list_QQ", @"title": @"加入书友群"},
        @{@"icon":@"profile_list_set", @"title":@"设置"}
    ];
    // Do any additional setup after loading the view.
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
        NSDictionary *dict = nil;
       if (indexPath.section == 0) {
           dict = [_section0Array objectAtIndex:indexPath.row];
       } else if ( indexPath.section == 1) {
           dict = [_section1Array objectAtIndex:indexPath.row];
       }
       
      
       NSString *title = [dict objectForKey:@"title"];
    if ([title isEqualToString:@"意见反馈"]) {
        [self openFeedbackViewController];
    } else if ([title isEqualToString:@"浏览历史"]) {
        BRHistoryBooksViewController *vc = [[BRHistoryBooksViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"关于软件"]) {
        BRAboutSoftViewController *vc = [[BRAboutSoftViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"免责声明"]){
        BRWebviewViewController *webVC = [[BRWebviewViewController alloc] init];
        webVC.loadHtmlName = @"mianzeshengming";
        webVC.headTitle = @"免责声明";
        [self.navigationController pushViewController:webVC animated:YES];
    } else if ([title isEqualToString:@"给我好评"]){
//        if (@available(iOS 10.3, *)) {
//            [SKStoreReviewController requestReview];
//        } else {
            NSString *appURL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@?action=write-review", [CFAltUtils AppStoreId]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL] options:nil completionHandler:^(BOOL success) {
                
            }];
//        }
    } else if ([title isEqualToString:@"分享给朋友"]) {
        NSString *appURL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", [CFAltUtils AppStoreId]];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:appURL];
        [self showSuccessMessage:@"App Store 链接，已复制"];

    } else if ([title isEqualToString:@"设置"]) {
        BRSettingViewController *vc = [[BRSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"小说缓存"]) {
        BRBookCacheViewController *vc = [[BRBookCacheViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"加入书友群"]) {
        [self joinGroup:nil key:nil];
    }
    
}

#pragma mark- UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"Identifier";
    BRSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[BRSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
    }
    NSDictionary *dict = nil;
    if (indexPath.section == 0) {
        dict = [_section0Array objectAtIndex:indexPath.row];
    } else if ( indexPath.section == 1) {
        dict = [_section1Array objectAtIndex:indexPath.row];
    }
    
    cell.icon = [dict objectForKey:@"icon"];
    cell.title = [dict objectForKey:@"title"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (section == 0) {
        rows = _section0Array.count;
    } else if ( section == 1) {
        rows = _section1Array.count;
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBRSettingTableViewCellHeight;
}

@end
