//
//  NSString+size.m
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "NSString+size.h"
#import <CoreText/CoreText.h>
#import "CFCustomMacros.h"
#import "GVUserDefaults+BRUserDefaults.h"


@implementation NSString (size)

+ (NSArray*)pagingWith:(NSString*)text Size:(CGSize)size {
    if (kDictIsEmpty(BRUserDefault.userReadAttConfig)){
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = kLineSpacingCustom;
        paragraphStyle.paragraphSpacing = kParagraphSpacingCustom;
        NSDictionary* dic = @{
                              NSFontAttributeName: [UIFont systemFontOfSize:KReadFontCustom],
                              NSForegroundColorAttributeName: CFUIColorFromRGBAInHex(0x311b0e, 1),
                              NSKernAttributeName: @(0),
                              NSParagraphStyleAttributeName: paragraphStyle,
                              };
        BRUserDefault.userReadAttConfig = dic;
    }
    NSAttributedString* att = [[NSAttributedString alloc] initWithString:text attributes:BRUserDefault.userReadAttConfig];
    return [self pagingWithAttStr:att Size:size];
}

+ (NSArray*)pagingWithAttStr:(NSAttributedString*)str Size:(CGSize)size {
    CFAttributedStringRef cfAttStr = (__bridge CFAttributedStringRef)str;
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString(cfAttStr);
    
    NSMutableArray* array = [NSMutableArray array];
    int nowLenght = 0;
    
    while (nowLenght<str.length)
    {
        CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), NULL);
        CTFrameRef frame = CTFramesetterCreateFrame(setterRef, CFRangeMake(nowLenght, 0), path, NULL);
        
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        NSRange range = NSMakeRange(frameRange.location, frameRange.length);
        
        NSString* string = [str.string substringWithRange:range];
        [array addObject:string];
        
        CGPathRelease(path);
        CFRelease(frame);
        
        if (string.length == 0){
            break;
        }else{
            nowLenght += string.length;
        }
    }
    
    CFRelease(setterRef);
    return array;
}

- (CGFloat)getAttributedStringHeightWithText:(NSAttributedString *)attributedString andWidth:(CGFloat)width andFont:(UIFont *)font
{
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    
    stringLabel.font = font;
    stringLabel.attributedText = attributedString;
    return [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

@end
