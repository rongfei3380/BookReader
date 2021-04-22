//
//  CFCustomMacros.h
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#ifndef CFCustomMacros_h
#define CFCustomMacros_h
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define CFDebugLog(FORMAT, ...) fprintf(stderr,"%s:[%s]%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define CFDebugLog(...)
#endif

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
#define BOTTOM_HEIGHT  isIPhoneXSeries() ? (49+34) : 49

/* 版本号 相关 */
//App版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// 当前系统版本
#define kFSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define kDSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define kSSystemVersion          ([[UIDevice currentDevice] systemVersion])

/* 内存管理 相关 */
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type)  __strong typeof(type) type = weak##type;



//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
#define kNumberIsEmpty(num) (num == nil || num.intValue <= 0)



static inline CGFloat kStatusBarHeight(){
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

//傻逼刘海屏的判断
static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}


//在Global Queue上运行
#define kDISPATCH_ON_GLOBAL_QUEUE_HIGH(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), globalQueueBlocl);
#define kDISPATCH_ON_GLOBAL_QUEUE_DEFAULT(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);
#define kDISPATCH_ON_GLOBAL_QUEUE_LOW(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), globalQueueBlocl);
#define kDISPATCH_ON_GLOBAL_QUEUE_BACKGROUND(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), globalQueueBlocl);

//快速调用主线程
#define kdispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define kdispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

// 阅读相关
#define KReadFontCustom 18

#define kFirstLineHeadIndent [UIFont systemFontOfSize:KReadFontCustom].pointSize *2

#define kLineSpacingCompact ([UIFont systemFontOfSize:18].pointSize*0.75 -([UIFont systemFontOfSize:18].lineHeight -[UIFont systemFontOfSize:18].pointSize))
#define kLineSpacingCustom ([UIFont systemFontOfSize:18].pointSize*1.05 -([UIFont systemFontOfSize:18].lineHeight -[UIFont systemFontOfSize:18].pointSize))
#define kLineSpacingLoose ([UIFont systemFontOfSize:18].pointSize*1.25 -([UIFont systemFontOfSize:18].lineHeight -[UIFont systemFontOfSize:18].pointSize))

#define kParagraphSpacingCompact ([UIFont systemFontOfSize:18].pointSize*0.1 -([UIFont systemFontOfSize:18].lineHeight -[UIFont systemFontOfSize:18].pointSize))
#define kParagraphSpacingCustom ([UIFont systemFontOfSize:18].pointSize*0.4 -([UIFont systemFontOfSize:18].lineHeight -[UIFont systemFontOfSize:18].pointSize))
#define kParagraphSpacingLoose ([UIFont systemFontOfSize:18].pointSize*0.9 -([UIFont systemFontOfSize:18].lineHeight -[UIFont systemFontOfSize:18].pointSize))

#endif /* CFCustomMacros_h */
