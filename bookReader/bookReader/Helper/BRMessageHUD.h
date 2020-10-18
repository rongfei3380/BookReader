//
//  BRMessageHUD.h
//  bookReader
//
//  Created by Jobs on 2020/7/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRMessageHUD : NSObject

+ (void)showSuccessMessage:(NSString *)message to:(UIView *)view;

+ (void)showErrorMessage:(NSError *)error to:(UIView *)view;
+ (void)showErrorStatus:(NSString *)errorStr to:(UIView *)view;
+ (void)showErrorMessage:(NSError *)error withDelay:(NSTimeInterval)delay to:(UIView *)view;

+ (void)showProgressMessage:(NSString *)message to:(UIView *)view;
+ (void)showProgressMessage:(NSString *)message closable:(BOOL)closable to:(UIView *)view;
+ (void)hideProgressMessageTo:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
