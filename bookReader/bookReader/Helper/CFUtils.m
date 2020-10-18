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

@end
