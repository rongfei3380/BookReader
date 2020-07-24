//
//  BRMessageHUD.m
//  bookReader
//
//  Created by Jobs on 2020/7/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRMessageHUD.h"
#import <MBProgressHUD.h>

@implementation BRMessageHUD

+ (NSString *)generateErrorMessage:(NSError *)error {
    NSString *msg = error.localizedDescription;
    return msg;
}

+ (void)showSuccessMessage:(NSString *)message  to:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
     UIImage *image = [[UIImage imageNamed:@"success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     
     UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
     
     hud.customView = imageView;
     hud.mode = MBProgressHUDModeCustomView;
     
    hud.label.text = message;
     
     [hud hideAnimated:YES afterDelay:3];
}


+ (void)showErrorMessage:(NSError *)error to:(UIView *)view{
    [self showErrorMessage:error withDelay:3 to:view];
}

+ (void)showErrorStatus:(NSString *)errorStr  to:(UIView *)view{
    NSError *error = [NSError errorWithDomain:@"com.chengfeir.bookread" code:0 userInfo:[NSDictionary dictionaryWithObject:errorStr forKey:@"NSLocalizedDescription"]];
    [self showErrorMessage:error to:view];
}

+ (void)showErrorMessage:(NSError *)error withDelay:(NSTimeInterval)delay to:(UIView *)view{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
       UIImage *image = [[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
       
       UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
       
       hud.customView = imageView;
       hud.mode = MBProgressHUDModeCustomView;
       
       hud.label.text = [self generateErrorMessage:error];
       
       [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showProgressMessage:(NSString *)message  to:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

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

+ (void)showProgressMessage:(NSString *)message closable:(BOOL)closable  to:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    // Set some text to show the initial status.
    hud.label.text = message;
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);

    [self hideProgressMessageTo:view];
}
+ (void)hideProgressMessageTo:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:3.f];
    });
}


@end
