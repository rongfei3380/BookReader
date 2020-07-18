//
//  CFCustomMacros.h
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#ifndef CFCustomMacros_h
#define CFCustomMacros_h
// 一些常用的宏


/* UI相关 */
// 通过RGB和Alpha值来获取UIColor对象
// 1. 16进制取色
#define CFUIColorFromRGBAInHex(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

// 三原色 取色
#define CFUIColorFromRGBA(red , green , blue , alphaValue) \
[UIColor \
colorWithRed:((float) red)/255.0 \
green:((float) green)/255.0 \
blue:((float) blue)/255.0 \
alpha:alphaValue]

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define STATUABAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height


static inline CGFloat  kStatusBarHeight (){
    CGRect statusRect = CGRectZero;
    if (@available(iOS 13.0, *)) {
           UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
           UIStatusBarManager *statusBarManager = keyWindow.windowScene.statusBarManager;
           statusRect = statusBarManager.statusBarFrame;
       }else {
           statusRect = [[UIApplication sharedApplication] statusBarFrame];
    }
    return statusRect.size.height;
}


/* 版本号 相关 */
//App版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 当前系统版本
#define kFSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define kDSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define kSSystemVersion          ([[UIDevice currentDevice] systemVersion])

/* 内存管理 相关 */
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type)  __strong typeof(type) type = weak##type;



#endif /* CFCustomMacros_h */
