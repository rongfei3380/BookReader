//
//  NSString+size.h
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFCustomMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (size)
/**
 * 分页
 * 给定size的大小和字符属性,计算需要几页才能显示,并返回分页后的数组。
 */
+ (NSArray*)pagingWithAttStr:(NSAttributedString*)str Size:(CGSize)size;

+ (NSArray*)pagingWith:(NSString*)text Size:(CGSize)size;

- (CGFloat)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
