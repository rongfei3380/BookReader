//
//  BRReadViewReusePool.m
//  bookReader
//
//  Created by chengfei on 2021/3/12.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRReadViewReusePool.h"

@interface BRReadViewReusePool ()

/**
 等待使用的队列
 */
@property(nonatomic, strong) NSMutableSet *waitUsedQueue;
/**
 使用中的队列
 */
@property(nonatomic, strong) NSMutableSet *usingQueue;

@end

@implementation BRReadViewReusePool

- (id)init {
    self = [super init];
    if (self != nil) {
        _waitUsedQueue = [NSMutableSet set];
        _usingQueue = [NSMutableSet set];
    }
    return self;
}

- (UIViewController *)dequeueReusebleView {
    UIViewController *viewController = [_waitUsedQueue anyObject];
    if (viewController == nil) {
        return nil;
    } else {
        [_waitUsedQueue removeObject:viewController];
        [_usingQueue addObject:viewController];
        return viewController;
    }
}

- (void)addUsingView:(UIViewController *)viewController {
    if (viewController == nil) {
        return;
    }
//    添加视图到使用中的队列
    [_usingQueue addObject:viewController];
}

- (void)reset {
    UIViewController *viewController = nil;
    while ((viewController = [_usingQueue anyObject])) {
//        从使用队列中移除
        [_usingQueue removeObject:viewController];
//        加入等待使用的队列
        [_waitUsedQueue addObject:viewController];
    }
}

@end
