//
//  GVUserDefaults+BRUserDefaults.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "GVUserDefaults+BRUserDefaults.h"

@implementation GVUserDefaults (BRUserDefaults)

@dynamic PageNaviDirection;
@dynamic PageTransitionStyle;
@dynamic PageNaviOrientation;
@dynamic userReadAttConfigData;
@dynamic isNightStyle;
@dynamic adLoadChapters;
@dynamic readInfoColor;
@dynamic readBrightness;
@dynamic readBackColorData;
@dynamic hotWordArr;


- (NSDictionary *)userReadAttConfig{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.userReadAttConfigData];
}

- (void)setUserReadAttConfig:(NSDictionary *)userReadAttConfig{
    self.userReadAttConfigData = [NSKeyedArchiver archivedDataWithRootObject:userReadAttConfig];
}

- (UIColor *)readBackColor{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.readBackColorData];
}

- (void)setReadBackColor:(UIColor *)readBackColor{
    self.readBackColorData = [NSKeyedArchiver archivedDataWithRootObject:readBackColor];
}

@end
