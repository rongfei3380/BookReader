//
//  CFDataUtils.m
//  bookReader
//
//  Created by Jobs on 2020/7/14.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "CFDataUtils.h"
#import "NSDate+Utilities.h"

@implementation CFDataUtils


+ (NSString *)createBookUpdateTime:(NSDate *)createdDate{
    // 1.获得dashboard的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //    NSDate *createdDate = [fmt dateFromString:_created_at];
    
    // 2..判断dashboard发送时间 和 现在时间 的差距
    if (createdDate.isToday) { // 今天
        if (createdDate.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%ld小时前", (long)createdDate.deltaWithNow.hour];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else {
        NSDateComponents *deltaWithNow = createdDate.deltaWithNow;
        NSInteger day = deltaWithNow.hour/24;
        
        if (day < 7) {
            return [NSString stringWithFormat:@"%ld天前", day];
        } else {
            return @"7天前";
        }
        
        return @"7天前";
    }
}

@end
