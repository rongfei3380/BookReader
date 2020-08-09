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

- (UIColor *)readBackColor{
    UIColor *color1 = CFUIColorFromRGBAInHex(0xf5f5f2, 1);
    UIColor *color2 = CFUIColorFromRGBAInHex(0xa39e8b, 1);
    UIColor *color3 = CFUIColorFromRGBAInHex(0xfbe1e1, 1);
    UIColor *color4 = CFUIColorFromRGBAInHex(0xd5e7c8, 1);

    UIColor *color5 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_one"]];
    UIColor *color6 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_two"]];
    UIColor *color7 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_three"]];
    UIColor *color8 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_four"]];
    
    NSArray *colorArray = @[color1, color2, color3, color4, color5, color6, color7, color8];
    
    
    return [colorArray objectAtIndex:self.readBackColorIndex];
}

- (void)setReadBackColor:(UIColor *)readBackColor{
    UIColor *color1 = CFUIColorFromRGBAInHex(0xf5f5f2, 1);
    UIColor *color2 = CFUIColorFromRGBAInHex(0xa39e8b, 1);
    UIColor *color3 = CFUIColorFromRGBAInHex(0xfbe1e1, 1);
    UIColor *color4 = CFUIColorFromRGBAInHex(0xd5e7c8, 1);

    UIColor *color5 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_wenli1_def"]];
    UIColor *color6 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_wenli2_def"]];
    UIColor *color7 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_wenli3_def"]];
    UIColor *color8 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reading_bg_wenli4_def"]];
   
    NSInteger index = 0;
    if (CGColorEqualToColor(readBackColor.CGColor, CFUIColorFromRGBAInHex(0xf5f5f2, 1).CGColor)){
        index = 0;
        
    } else if (CGColorEqualToColor(readBackColor.CGColor, CFUIColorFromRGBAInHex(0xa39e8b, 1).CGColor)){
       index = 1;
    }else if (CGColorEqualToColor(readBackColor.CGColor, CFUIColorFromRGBAInHex(0xfbe1e1, 1).CGColor)){
        index = 2;
        
    }else if (CGColorEqualToColor(readBackColor.CGColor, CFUIColorFromRGBAInHex(0xd5e7c8, 1).CGColor)){
        index = 3;
    }else if (CGColorEqualToColor(readBackColor.CGColor, color5.CGColor)){
       index = 4;
    }else if (CGColorEqualToColor(readBackColor.CGColor, color6.CGColor)){
       index = 5;
    }else if (CGColorEqualToColor(readBackColor.CGColor, color7.CGColor)){
        index = 6;
    }else if (CGColorEqualToColor(readBackColor.CGColor, color8.CGColor)){
       index = 7;
    }
    self.readBackColorIndex = index;
}

@end
