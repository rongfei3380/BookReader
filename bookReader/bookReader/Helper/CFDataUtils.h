//
//  CFDataUtils.h
//  bookReader
//
//  Created by Jobs on 2020/7/14.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/// 用来处理时间显示的一些方法
@interface CFDataUtils : NSObject


+ (NSString *)createBookUpdateTime:(NSDate *)createdDate;




@end

NS_ASSUME_NONNULL_END
