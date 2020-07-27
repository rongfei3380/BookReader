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
@property (nonatomic, strong) UIImage *emptyImg; //页面为空时提示图片
@property (nonatomic, strong) NSString *emptyString;  //页面为空时提示文字
@property (nonatomic,assign) BOOL isFirstLoad;


#pragma mark- public
- (void)goBookInfoViewWIthBook:(BRBookInfoModel *)book;

/**
 获取数据为空时的图片
 */
- (UIImage *)fetchEmptyImage;
/**
 获取数据为空时的空字符串
 */
- (NSString *)fetchEmptyString;

#pragma mark- ProgressHUD

- (void)showSuccessMessage:(NSString *)message;

- (void)showErrorMessage:(NSError *)error;
- (void)showErrorStatus:(NSString *)errorStr;
- (void)showErrorMessage:(NSError *)error withDelay:(NSTimeInterval)delay;

- (void)showProgressMessage:(NSString *)message;
- (void)showProgressMessage:(NSString *)message closable:(BOOL)closable;
- (void)hideProgressMessage;

#pragma mark- Cache

///  缓存数据
/// @param records 需要缓存的数据
- (void)cacheRecords:(NSArray *)records key:(NSString *)key;

/// 获取缓存的数据
- (NSArray *)getCacheRecordsWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
