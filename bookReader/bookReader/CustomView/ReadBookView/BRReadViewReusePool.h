//
//  BRReadViewReusePool.h
//  bookReader
//
//  Created by chengfei on 2021/3/12.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 用于 阅读页面的 重用池
@interface BRReadViewReusePool : NSObject

- (UIViewController *)dequeueReusebleView;

- (void)addUsingView:(nullable UIViewController *)view;

- (void)reloadData;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
