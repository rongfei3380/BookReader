//
//  CFUtils.h
//  bookReader
//
//  Created by Jobs on 2020/9/14.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFUtils : NSObject

/**
 获的一张纯色的图片
 @param color  颜色值
 @param size   图片的大小
 */
+ (UIImage *)pureColorImage:(int)color colorAlpha:(CGFloat)alpha size:(CGSize)size;

+ (NSMutableParagraphStyle *)defaultParagraphStyleWithFontOfSize:(CGFloat)size lineSpacing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
