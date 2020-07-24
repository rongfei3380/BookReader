//
//  BRBaseViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/7.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCustomMacros.h"
#import "Masonry.h"
#import "NSError+BRError.h"
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum _BaseViewEnableModule {
    BaseViewEnableModuleNone = 0,
    BaseViewEnableModuleHeadView = 1 << 0,     // 导航栏
    BaseViewEnableModuleBackBtn = 1 << 1,     // 返回键
    BaseViewEnableModuleTitle = 1 << 2,     // title
} BaseViewEnableModule;

@interface BRBaseViewController : UIViewController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong, readonly) UIView *headView;
@property(nonatomic, assign) BaseViewEnableModule enableModule;
@property(nonatomic, strong) NSString *headTitle;


#pragma mark- public
- (void)goBookInfoViewWIthBook:(BRBookInfoModel *)book;

#pragma mark- ProgressHUD

- (void)showSuccessMessage:(NSString *)message;

- (void)showErrorMessage:(NSError *)error;
- (void)showErrorStatus:(NSString *)errorStr;
- (void)showErrorMessage:(NSError *)error withDelay:(NSTimeInterval)delay;

- (void)showProgressMessage:(NSString *)message;
- (void)showProgressMessage:(NSString *)message closable:(BOOL)closable;
- (void)hideProgressMessage;


@end

NS_ASSUME_NONNULL_END
