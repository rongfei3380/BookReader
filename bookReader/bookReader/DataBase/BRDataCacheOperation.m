//
//  BRDataCacheOperation.m
//  bookReader
//
//  Created by Jobs on 2021/1/9.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRDataCacheOperation.h"
#import <UIKit/UIKit.h>
#import "BRCacheTask.h"
#import "BRChapterDetail.h"
#import "CFCustomMacros.h"
#import "BRDataBaseCacheManager.h"

NSString *const BRCacheStartNotification = @"BRCacheStartNotification";
NSString *const BRCacheReceiveResponseNotification = @"BRCacheReceiveResponseNotification";
NSString *const BRCacheStopNotification = @"BRCacheStopNotification";
NSString *const BRCacheFinishNotification = @"BRCacheFinishNotification";

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

typedef NSMutableDictionary<NSString *, id> BRCallbacksDictionary;

@interface BRDataCacheOperation ()

@property (strong, nonatomic, nonnull) NSMutableArray<BRCallbacksDictionary *> *callbackBlocks;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

/// 已缓存章节数
@property (assign, nonatomic) long long totalCountCached;
/// 预期缓存章节数
@property (assign, nonatomic) long long totalCountExpectedToCache;

@property (strong, nonatomic) BRCacheTask *cacheTask;

@end

@implementation BRDataCacheOperation

@synthesize executing = _executing;
@synthesize finished = _finished;


- (BRCacheTask *)cacheTask {
    if (_cacheTask) {
        
    }
    return  _cacheTask;
}

- (nonnull instancetype)init {
    return [self initWithCacheTask:nil];
}

- (nonnull instancetype)initWithCacheTask:(nullable BRCacheTask *)cacheTask {
    if ((self = [super init])) {
        _cacheTask = cacheTask;
        _callbackBlocks = [NSMutableArray new];
        _executing = NO;
        _finished = NO;
        _barrierQueue = dispatch_queue_create("com.bookread.BRCacheOperationBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        
        [self.cacheTask setState:BRCacheTaskStateWillResume];
    }
    return self;
}

- (nullable NSArray<id> *)callbacksForKey:(NSString *)key {
    __block NSMutableArray<id> *callbacks = nil;
    dispatch_sync(self.barrierQueue, ^{
        // We need to remove [NSNull null] because there might not always be a progress block for each callback
        callbacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
        [callbacks removeObjectIdenticalTo:[NSNull null]];
    });
    return [callbacks copy];    // strip mutability here
}

- (nullable id)addHandlersForProgress:(nullable BRDataCacheProgressBlock)progressBlock
                            completed:(nullable BRDataCacheCompletedBlock)completedBlock {
    BRCallbacksDictionary *callbacks = [NSMutableDictionary new];
    if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
    if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.callbackBlocks addObject:callbacks];
    });
    return callbacks;
}

- (void)callCompletionBlocksWithError:(nullable NSError *)error {
    [self callCompletionBlocksWithCacheTask:self.cacheTask error:error finished:YES];
}

- (void)callCompletionBlocksWithCacheTask:(nullable BRCacheTask *)cacheTask
                                error:(nullable NSError *)error
                             finished:(BOOL)finished {
    
    if (error) {
        [cacheTask setState:BRCacheTaskStateFailed];
    }else {
        [cacheTask setState:BRCacheTaskStateCompleted];
    }
    
    NSArray<id> *completionBlocks = [self callbacksForKey:kCompletedCallbackKey];

    kdispatch_main_async_safe(^{
        for (BRDataCacheCompletedBlock completedBlock in completionBlocks) {
            completedBlock(cacheTask, error, finished);
        }

        if (self.cacheTask.cacheCompletedBlock) {
            self.cacheTask.cacheCompletedBlock(cacheTask, error, YES);
        }
    });
}
#pragma mark- private
- (void)chacheContentWithChapterId:(NSNumber *)chapterId completed:(void(^)(void))completed{
    kWeakSelf(self)
    if (self.isCancelled || self.suspended) {
        return;
    }
    if (self.cacheTask.toCacheChapterIds.count == 0 || !self.cacheTask.toCacheChapterIds) {
        return;
    }
    
    self.cacheTask.state = BRCacheTaskStateDownloading;
    
    CFDebugLog(@"要缓存第 %ld 个了", self.cacheTask.cachedChapterIds.count);
    [BRChapterDetail getChapterContentWithBookId:self.cacheTask.bookId chapterId:[self.cacheTask.toCacheChapterIds firstObject].integerValue siteId:self.cacheTask.siteId.integerValue sucess:^(BRChapterDetail * _Nonnull chapterDetail) {
        CFDebugLog(@"已完成缓存第 %ld 个了", self.cacheTask.cachedChapterIds.count);
        kStrongSelf(self)
        kDISPATCH_ON_GLOBAL_QUEUE_LOW((^{
            if (self.cacheTask.toCacheChapterIds.count > 1) {
                CFDebugLog(@"toCacheChapterIds count %ld", self.cacheTask.toCacheChapterIds.count);
                CFDebugLog(@"cachedChapterIds count %ld", self.cacheTask.cachedChapterIds.count);
                [self.cacheTask.cachedChapterIds addObject:[self.cacheTask.toCacheChapterIds firstObject]];
                [self.cacheTask.toCacheChapterIds removeObjectAtIndex:0];
                
                // 用来更新已缓存的章节数
                NSMutableDictionary *dict = [BRDataBaseCacheManager sharedInstance].allCacheTaskes;
                NSString *key = [NSString stringWithFormat:@"%@+%@", self.cacheTask.bookId, self.cacheTask.siteId];
                if (dict && key && self.cacheTask) {
                    [dict setObject:self.cacheTask forKey:key];
                }
                                        
                for (BRDataCacheProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
                    progressBlock([self.cacheTask allChapterCount] -self.cacheTask.toCacheChapterIds.count, [self.cacheTask allChapterCount], self.cacheTask);
                }
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [[NSNotificationCenter defaultCenter] postNotificationName:BRCacheReceiveResponseNotification object:self];
//                        });
                kdispatch_main_sync_safe(^{
                    [[BRDataBaseCacheManager sharedInstance] saveAllCacheTask];
                });
                [self chacheContentWithChapterId:nil completed:nil];
            } else {
                CFDebugLog(@"==========最后一个下载的处理==========");
                CFDebugLog(@"toCacheChapterIds count %ld", self.cacheTask.toCacheChapterIds.count);
                CFDebugLog(@"cachedChapterIds count %ld", self.cacheTask.cachedChapterIds.count);
                
                [self.cacheTask.cachedChapterIds addObject:[self.cacheTask.toCacheChapterIds firstObject]];
                [self.cacheTask.toCacheChapterIds removeObjectAtIndex:0];
                
                BRCacheTask *task = self.cacheTask;
                [task setState:BRCacheTaskStateCompleted];
                self.cacheTask.state = BRCacheTaskStateCompleted;
                // 用来更新已缓存的章节数
                NSMutableDictionary *dict = [BRDataBaseCacheManager sharedInstance].allCacheTaskes;
                NSString *key = [NSString stringWithFormat:@"%@+%@", self.cacheTask.bookId, self.cacheTask.siteId];
                if (dict && key && self.cacheTask) {
                    [dict setObject:self.cacheTask forKey:key];
                }
                
                CFDebugLog(@"+++++最后一个章节了+++++");
                if ([self callbacksForKey:kCompletedCallbackKey].count > 0) {
                    CFDebugLog(@"+++++最后一个章节了+++++");
                    [[NSNotificationCenter defaultCenter] postNotificationName:BRCacheFinishNotification object:self];
                    [self callCompletionBlocksWithCacheTask:task error:nil finished:YES];
                }
                kdispatch_main_async_safe(^{
                    if (self.cacheTask.cacheCompletedBlock) {
                        self.cacheTask.cacheCompletedBlock(task, nil, YES);
                    }
                });
                kdispatch_main_sync_safe(^{
                    [[BRDataBaseCacheManager sharedInstance] saveAllCacheTask];
                });

                [self done];
            }
        }));
        [[BRDataBaseCacheManager sharedInstance] saveAllCacheTask];
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        self.cacheTask.state = BRCacheTaskStateFailed;
        [self callCompletionBlocksWithError:error];
    }];
}

- (BOOL)cancel:(nullable id)token {
    __block BOOL shouldCancel = NO;
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.callbackBlocks removeAllObjects];
        if (self.callbackBlocks.count == 0) {
            shouldCancel = YES;
        }
    });
    if (shouldCancel) {
        [self cancel];
    }
    return shouldCancel;
}

- (BOOL)suspended:(nullable id)token{
    __block BOOL suspended = YES;
    self.suspended = YES;
    if (suspended) {
        if (self.isFinished) return suspended;
        [super cancel];
        if (self.cacheTask) {
            [self.cacheTask setState:BRCacheTaskStateNone];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:BRCacheStopNotification object:self];
            });
            // As we cancelled the connection, its callback won't be called and thus won't
            // maintain the isFinished and isExecuting flags.
            if (self.isExecuting) self.executing = NO;
            if (!self.isFinished) self.finished = YES;
        }
    }
    return suspended;
}

#pragma mark- overload
- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }
        
#if TARGET_OS_IOS
        Class UIApplicationClass = NSClassFromString(@"UIApplication");
        BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
        if (hasApplication && [self shouldContinueWhenAppEntersBackground]) {
            __weak __typeof__ (self) wself = self;
            UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
            self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
                __strong __typeof (wself) sself = wself;
                
                if (sself) {
                    [sself cancel];
                    
                    [app endBackgroundTask:sself.backgroundTaskId];
                    sself.backgroundTaskId = UIBackgroundTaskInvalid;
                }
            }];
        }
#endif
        self.executing = YES;
    }
    // 执行的任务
    if (self.cacheTask) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BRCacheStartNotification object:self];
       
        [self.cacheTask setState:BRCacheTaskStateDownloading];
        [self chacheContentWithChapterId:nil completed:^{
            
        }];
    } else {
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Connection can't be initialized"}]];
    }

    
#if TARGET_OS_IOS
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
#endif
}

- (void)cancel {
    @synchronized (self) {
        [self cancelInternal];
    }
}

- (void)cancelInternal {
    if (self.isFinished) return;
    [super cancel];
    if (self.cacheTask) {
        [self.cacheTask setState:BRCacheTaskStateNone];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BRCacheStopNotification object:self];
        });
        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [[BRDataBaseCacheManager sharedInstance] saveAllCacheTask];
    
    NSString *key = [NSString stringWithFormat:@"%@+%@", _cacheTask.bookId, _cacheTask.siteId];
    [[BRDataBaseCacheManager sharedInstance].cacheOperations removeObjectForKey:key];
    
    [self reset];
}

- (void)reset {
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.callbackBlocks removeAllObjects];
    });
//    self.dataTask = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark--
- (BOOL)shouldContinueWhenAppEntersBackground {
    return YES;
}

@end
