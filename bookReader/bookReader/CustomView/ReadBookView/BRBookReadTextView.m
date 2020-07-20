//
//  BRBookReadTextView.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookReadTextView.h"
#import "CFCustomMacros.h"
#import "GVUserDefaults+BRUserDefaults.h"
#import <CoreText/CoreText.h>

@implementation BRBookReadTextView

- (instancetype)initWithText:(NSString*)text {
    self = [super init];
    if (self){
        self.text = text;
        self.backgroundColor = [UIColor redColor];

//        self.backgroundColor = BRUserDefault.readBackColor?:CFUIColorFromRGBAInHex(0xFFFFFF, 1);
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 翻转坐标系*/
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:BRUserDefault.userReadAttConfig];
    if (BRUserDefault.isNightStyle){
        [dic setObject:CFUIColorFromRGBAInHex(0x576071, 1) forKey:NSForegroundColorAttributeName];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text?:@"" attributes:dic];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height), NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attrString length]), path, NULL);
    
    /* 绘制文本*/
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}


@end
