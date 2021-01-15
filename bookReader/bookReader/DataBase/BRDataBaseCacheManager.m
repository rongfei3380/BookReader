//
//  BRDataBaseCacheManager.m
//  bookReader
//
//  Created by Jobs on 2020/12/26.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRDataBaseCacheManager.h"
#import <UIKit/UIKit.h>
#import "BRDataCacheOperation.h"
#import "CFCustomMacros.h"
#import "YYDiskCache.h"

static inline dispatch_queue_t BRDataBaseCacheManagerQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

@interface BRDataBaseCacheManager ()

@property (strong, nonatomic, nonnull) NSOperationQueue *cacheQueue;
@property (weak, nonatomic, nullable) NSOperation *lastAddedOperation;
@property (assign, nonatomic, nullable) Class operationClass;

// This queue is used to serialize the handling of the network responses of all the download operation in a single queue
@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

@end


@implementation BRDataBaseCacheManager

@synthesize allCacheTaskes = _allCacheTaskes;

+ (instancetype)sharedInstance {
    static BRDataBaseCacheManager *dataBase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBase = [[BRDataBaseCacheManager alloc] init];
    });
    return dataBase;
}

- (nonnull instancetype)init {
    if ((self = [super init])) {
        _operationClass = [BRDataCacheOperation class];
        _cachePrioritizaton = BRCachePrioritizationFIFO;
        _cacheQueue = [NSOperationQueue new];
        _cacheQueue.maxConcurrentOperationCount = 5;
        _cacheQueue.name = @"com.chapter.cache";
        _barrierQueue = dispatch_queue_create("com.machao.MCDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _cacheOperations = [NSMutableDictionary new];
//        _allCacheTaskes  = [NSMutableDictionary new];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [self.cacheQueue cancelAllOperations];

}


#pragma mark- getter

- (NSMutableDictionary <NSString *,BRCacheTask *>*)allCacheTaskes {
    
    if (_allCacheTaskes == nil) {
        NSDictionary *receipts = [self getCacheRecordsWithKey:@"chapterDetail_cache"];
        _allCacheTaskes = receipts != nil ? receipts.mutableCopy : [NSMutableDictionary dictionary];
    }
    return _allCacheTaskes;
}

#pragma mark- setter

- (void)setMaxConcurrentCaches:(NSInteger)maxConcurrentCaches {
    _cacheQueue.maxConcurrentOperationCount = maxConcurrentCaches;
}

- (NSUInteger)currentDownloadCount {
    return _cacheQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads {
    return _cacheQueue.maxConcurrentOperationCount;
}

- (void)setOperationClass:(nullable Class)operationClass {
    if (operationClass && [operationClass isSubclassOfClass:[NSOperation class]] && [operationClass conformsToProtocol:@protocol(BRDataCacheOperationInterface)]) {
        _operationClass = operationClass;
    } else {
        _operationClass = [BRDataCacheOperation class];
    }
}

#pragma mark-- private
- (void)setAllStateToNone {
    [self.allCacheTaskes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BRCacheTask class]]) {
            BRCacheTask *receipt = obj;
            if (receipt.state != BRCacheTaskStateCompleted) {
                [receipt setState:BRCacheTaskStateNone];
            }
        }
    }];
}

- (void)saveAllCacheTask {
    [[BRDataBaseCacheManager sharedInstance] cacheRecords:_allCacheTaskes key:@"chapterDetail_cache"];
}
#pragma mark - Control Methods

- (void)suspended:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed{
    dispatch_barrier_async(self.barrierQueue, ^{
        NSString *key = [NSString stringWithFormat:@"%@+%@", token.bookId, token.siteId];
        BRDataCacheOperation *operation = self.cacheOperations[key];
        BOOL canceled = [operation suspended:token.cacheOperationCancelToken];
        if (canceled) {
            [self.cacheOperations removeObjectForKey:key];
            [token setState:BRCacheTaskStateWillResume];
            //            [self.allDownloadReceipts removeObjectForKey:token.url];
        }
        kdispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    });

}

- (void)resume:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed{
    dispatch_barrier_async(self.barrierQueue, ^{
        NSString *key = [NSString stringWithFormat:@"%@+%@", token.bookId, token.siteId];
        BRDataCacheOperation *operation = self.cacheOperations[key];
        operation.suspended = NO;
        [token setState:BRCacheTaskStateWillResume];
        
        if(!operation) {
            operation = [[BRDataCacheOperation alloc] initWithCacheTask:token];
            self.cacheOperations[key] = operation;
        }
        if (!operation.isExecuting) {
            [self.cacheQueue addOperation:operation];
        }
        
        kdispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    });
}


- (void)cancel:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed {
    dispatch_barrier_async(self.barrierQueue, ^{
        NSString *key = [NSString stringWithFormat:@"%@+%@", token.bookId, token.siteId];
        BRDataCacheOperation *operation = self.cacheOperations[key];
        BOOL canceled = [operation cancel:token.cacheOperationCancelToken];
        if (canceled || !operation) {
            [self.cacheOperations removeObjectForKey:key];
            [token setState:BRCacheTaskStateNone];
            [self.allCacheTaskes removeObjectForKey:key];
            [self saveAllCacheTask];
        }
        kdispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    });
}

- (void)remove:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed {
    [token setState:BRCacheTaskStateNone];
    [self cancel:token completed:^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
    
//        [fileManager removeItemAtPath:token.filePath error:nil];
        
        kdispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    }];
}

#pragma mark- Cache

///  缓存数据
/// @param records 需要缓存的数据
- (void)cacheRecords:(id )records key:(NSString *)key {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    
    YYDiskCache *recordsCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:NSStringFromClass([self class])] inlineThreshold:0];
   
    
    NSString *cacheKey = nil;
   if (key) {
       cacheKey =[NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
   } else {
       cacheKey = NSStringFromClass([self class]);
   }
    [recordsCache setObject:records forKey:cacheKey];
}

/// 获取缓存的数据
- (id )getCacheRecordsWithKey:(NSString *)key {
        
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
        
    YYDiskCache *recordsCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:NSStringFromClass([self class])] inlineThreshold:0];
    NSString *cacheKey = nil;
    if (key) {
        cacheKey =[NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
    } else {
        cacheKey = NSStringFromClass([self class]);
    }
    id object = (id)[recordsCache objectForKey:cacheKey];
    return object;

}

- (NSArray <NSNumber *> *)getableCacheChapterIdsWithTask:(BRCacheTask *)task chapterIds:(NSArray *)chapterIds{
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:task.toCacheChapterIds];
    NSMutableSet *set2 = [NSMutableSet setWithArray:chapterIds];
    [set1 unionSet:set2];
    NSMutableArray *toCacheIds = [NSMutableArray arrayWithArray:[set1 allObjects]];
    
    return toCacheIds;
}

#pragma mark-- Public
- (nullable BRCacheTask *)cacheChapterContentWithBook:(BRBookInfoModel *)book
                                           chapterIds:(NSArray *)chapterIds
                                               siteId:(NSNumber *)siteId
                                             progress:(nullable BRDataCacheProgressBlock)progressBlock
                                            completed:(nullable BRDataCacheCompletedBlock)completedBlock {
    kWeakSelf(self)
    BRCacheTask *task = [self cacheTaskForBook:book chapterIds:chapterIds siteId:siteId];
    if (task.state == BRCacheTaskStateCompleted) {
        
        if (chapterIds.count > 0) {

            return [self addProgressCallback:progressBlock completedBlock:completedBlock forBook:book chapterIds:chapterIds siteId:siteId createCallback:^BRDataCacheOperation *{
                kStrongSelf(self)
                BRCacheTask *task = [self cacheTaskForBook:book chapterIds:chapterIds siteId:siteId];
                BRDataCacheOperation *operation = [[BRDataCacheOperation alloc] initWithCacheTask:task];
                [self.cacheQueue addOperation:operation];
                NSString *key = [NSString stringWithFormat:@"%@+%@", task.bookId, task.siteId];
                [self->_cacheOperations setObject:operation forKey:key];
                
                if (self.cachePrioritizaton == BRCachePrioritizationLIFO) {
                    // Emulate LIFO execution order by systematically adding new operations as last operation's dependency
                    [self.lastAddedOperation addDependency:operation];
                    self.lastAddedOperation = operation;
                }
                
                return operation;
            }];
        } else {
            kdispatch_main_async_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:BRCacheFinishNotification object:self];
                if (completedBlock) {
                    completedBlock(task ,nil ,YES);
                }
                if (task.cacheCompletedBlock) {
                    task.cacheCompletedBlock(task, nil, YES);
                }
            });
            return task;
        }
    }
    
    return [self addProgressCallback:progressBlock completedBlock:completedBlock forBook:book chapterIds:chapterIds siteId:siteId createCallback:^BRDataCacheOperation *{
        kStrongSelf(self)
        BRCacheTask *task = [self cacheTaskForBook:book chapterIds:chapterIds siteId:siteId];
        BRDataCacheOperation *operation = [[BRDataCacheOperation alloc] initWithCacheTask:task];
        [self.cacheQueue addOperation:operation];
        NSString *key = [NSString stringWithFormat:@"%@+%@", task.bookId, task.siteId];
        [self->_cacheOperations setObject:operation forKey:key];
        
        if (self.cachePrioritizaton == BRCachePrioritizationLIFO) {
            // Emulate LIFO execution order by systematically adding new operations as last operation's dependency
            [self.lastAddedOperation addDependency:operation];
            self.lastAddedOperation = operation;
        }
        
        return operation;
    }];
}

- (BRCacheTask *)cacheTaskForBook:(BRBookInfoModel *)book chapterIds:(NSArray *)chapterIds siteId:(NSNumber *)siteId {
    
    
    if (book.bookId == nil || chapterIds.count == 0 || siteId == nil) {
        return nil;
    }
    NSString *cacheKey = [NSString stringWithFormat:@"%@+%@", book.bookId, siteId];
    
    if (self.allCacheTaskes[cacheKey]) {
        BRCacheTask *task = self.allCacheTaskes[cacheKey];
        if (task.toCacheChapterIds.count < chapterIds.count) {
            task.state = BRCacheTaskStateWillResume;
        }
        return task;
    } else {
        BRCacheTask *task = [[BRCacheTask alloc] initWithBookId:book.bookId bookName:book.bookName cover:book.cover chapterIds:chapterIds siteId:siteId cacheOperationCancelToken:nil cacheProgressBlock:nil cacheCompletedBlock:nil];
        [self.allCacheTaskes setObject:task forKey:cacheKey];
        return task;
    }
    
    return nil;
}

- (nullable BRCacheTask *)addProgressCallback:(BRDataCacheProgressBlock)progressBlock
                               completedBlock:(BRDataCacheCompletedBlock)completedBlock
                                      forBook:(BRBookInfoModel *)book
                                   chapterIds:(NSArray *)chapterIds
                                       siteId:(NSNumber *)siteId
                               createCallback:(BRDataCacheOperation *(^)(void))createCallback {
    if (book == nil || book.bookId == nil || siteId == nil || chapterIds == nil || chapterIds.count == 0) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, NO);
        }
        return nil;
    }
//
    __block BRCacheTask *token = nil;
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        NSString *operationKey = [NSString stringWithFormat:@"%@+%@", book.bookId, siteId];
        BRDataCacheOperation *operation = self.cacheOperations[operationKey];
        if (!operation) {
            operation = createCallback();
            self.cacheOperations[operationKey] = operation;

            __weak BRDataCacheOperation *woperation = operation;
            operation.completionBlock = ^{
                BRDataCacheOperation *soperation = woperation;
                if (!soperation) return;
                if (self.cacheOperations[operationKey] == soperation) {
                    [self.cacheOperations removeObjectForKey:operationKey];
                };
            };
        }
        id cacheOperationCancelToken = [operation addHandlersForProgress:progressBlock completed:completedBlock];

        if (!self.allCacheTaskes[operationKey]) {
            token = [[BRCacheTask alloc] initWithBookId:book.bookId bookName:book.bookName cover:book.cover chapterIds:chapterIds siteId:siteId cacheOperationCancelToken:cacheOperationCancelToken cacheProgressBlock:nil cacheCompletedBlock:nil];
            self.allCacheTaskes[operationKey] = token;
        }else {
            token = self.allCacheTaskes[operationKey];
            [token addCacheChapterIds:chapterIds];
            if (!token.cacheOperationCancelToken) {
                [token setCacheOperationCancelToken:cacheOperationCancelToken];
            }
        }

    });
    
    return token;
}

#pragma mark -  NSNotification
- (void)applicationWillTerminate:(NSNotification *)not {
    [self setAllStateToNone];
    [self saveAllCacheTask];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)not {
    [self saveAllCacheTask];
}

- (void)applicationWillResignActive:(NSNotification *)not {
    [self saveAllCacheTask];
    /// 捕获到失去激活状态后
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    if (hasApplication ) {
        __weak __typeof__ (self) wself = self;
        UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
        self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
            __strong __typeof (wself) sself = wself;
            
            if (sself) {
                [sself setAllStateToNone];
                [sself saveAllCacheTask];
                
                [app endBackgroundTask:sself.backgroundTaskId];
                sself.backgroundTaskId = UIBackgroundTaskInvalid;
            }
        }];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)not {
    
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
    

    [self.allCacheTaskes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BRCacheTask class]]) {
            BRCacheTask *cacheTask = obj;
            if (cacheTask.state != BRCacheTaskStateCompleted) {
                cacheTask.state = BRCacheTaskStateNone;
            }
        }
    }];
}

@end
