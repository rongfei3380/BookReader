//
//  UIPageViewController+Fix.m
//  bookReader
//
//  Created by Jobs on 2020/11/23.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "UIPageViewController+Fix.h"
#import <objc/runtime.h>

@implementation UIPageViewController (Fix)

+ (void)hyFix {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method dstMet = class_getInstanceMethod([UIPageViewController class], NSSelectorFromString(@"_setViewControllers:withCurlOfType:fromLocation:direction:animated:notifyDelegate:completion:"));
        Method srcMet = class_getInstanceMethod(self, @selector(hyFix_setViewControllers:withCurlOfType:fromLocation:direction:animated:notifyDelegate:completion:));
        method_exchangeImplementations(dstMet, srcMet);
    });
}

- (void)hyFix_setViewControllers:(nullable NSArray<UIViewController *> *)viewControllers
                  withCurlOfType:(UIPageViewControllerTransitionStyle)type
                    fromLocation:(CGPoint)location
                       direction:(UIPageViewControllerNavigationDirection)direction
                        animated:(BOOL)animated
                  notifyDelegate:(BOOL)notifyDelegate
                      completion:(void (^ __nullable)(BOOL finished))completion {
    if (!viewControllers.count) return;
    
    [self hyFix_setViewControllers:viewControllers withCurlOfType:type fromLocation:location direction:direction animated:animated notifyDelegate:notifyDelegate completion:completion];
}


+ (void)initialize {
    [UIPageViewController hyFix];
}


@end
