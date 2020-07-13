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

@end

NS_ASSUME_NONNULL_END
