//
//  CFUtils.m
//  bookReader
//
//  Created by Jobs on 2020/9/14.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "CFUtils.h"
#import "CFCustomMacros.h"

@implementation CFUtils

+ (UIImage *)pureColorImage:(int)color colorAlpha:(CGFloat)alpha size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [CFUIColorFromRGBAInHex(color, alpha) set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

+ (NSMutableParagraphStyle *)defaultParagraphStyleWithFontOfSize:(CGFloat)size lineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setMinimumLineHeight:25];
    [paragraphStyle setMaximumLineHeight:30];
    // 确保垂直居中
    paragraphStyle.minimumLineHeight = [UIFont systemFontOfSize:size].lineHeight - ([UIFont systemFontOfSize:size].lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    return paragraphStyle;
}

@end
