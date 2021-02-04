//
//  GVUserDefaults+BRUserDefaults.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "GVUserDefaults+BRUserDefaults.h"
#import "CFCustomMacros.h"

@implementation GVUserDefaults (BRUserDefaults)

- (NSDictionary *)userReadAttConfig{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.userReadAttConfigData];
}

- (void)setUserReadAttConfig:(NSDictionary *)userReadAttConfig{
    self.userReadAttConfigData = [NSKeyedArchiver archivedDataWithRootObject:userReadAttConfig];
}

- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIColor *)readBackColor{
    UIColor *color1 = CFUIColorFromRGBAInHex(0xFFFFFF, 1);
    UIColor *color2 = CFUIColorFromRGBAInHex(0xE5E2D1, 1);
    UIColor *color3 = CFUIColorFromRGBAInHex(0xC3CCC2, 1);
    UIColor *color4 = CFUIColorFromRGBAInHex(0xDAD9D7, 1);
    
    UIColor *color9 = CFUIColorFromRGBAInHex(0xEEE9E9, 1);
    UIColor *color10 = CFUIColorFromRGBAInHex(0xDAE5E8, 1);

    UIColor *color5 = [UIColor colorWithPatternImage:[self imageResize:[UIImage imageNamed:@"reading_bg_one"] andResizeTo:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];
    UIColor *color6 = [UIColor colorWithPatternImage: [self imageResize:[UIImage imageNamed:@"reading_bg_two"] andResizeTo:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];
    UIColor *color7 = [UIColor colorWithPatternImage:[self imageResize:[UIImage imageNamed:@"reading_bg_three"] andResizeTo:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];
    UIColor *color8 = [UIColor colorWithPatternImage:[self imageResize:[UIImage imageNamed:@"reading_bg_four"] andResizeTo:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];
    UIColor *color11 = [UIColor colorWithPatternImage:[self imageResize:[UIImage imageNamed:@"reading_bg_six"] andResizeTo:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];
    
    NSArray *colorArray = @[color11, color1, color2, color3, color4, color9, color10, color5, color6, color7, color8];
    
    if(self.readBackColorIndex >= colorArray.count) {
        self.readBackColorIndex  = 0 ;
    }
    return [colorArray objectAtIndex:self.readBackColorIndex];
}

@end
