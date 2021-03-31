//
//  BRDataBaseCacheManager.h
//  bookReader
//
//  Created by Jobs on 2020/12/26.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRCacheTask.h"
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


extern NSString * _Nonnull const MCDownloadStartNotification;
extern NSString * _Nonnull const MCDownloadStopNotification;


/// 用来处理章节缓存的管理类

@interface BRDataBaseCacheManager : NSObject


/**
 *  The maximum number of concurrent Caches
 */
@property (assign, nonatomic) NSInteger maxConcurrentCaches;

/**
 * Shows the current amount of caches that still need to be downloaded
 */
@property (readonly, nonatomic) NSUInteger currentCachedCount;

/**
 Defines the order prioritization of incoming download requests being inserted into the queue. `BRCachePrioritizationFIFO` by default.
 */
@property (nonatomic, assign) BRCachePrioritization cachePrioritizaton;

/// key : BookId+siteId
@property (nonatomic, strong) NSMutableDictionary <NSString *,BRCacheTask *>*allCacheTaskes;
/// 任务 key: bookId+siteId
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSString *, BRDataCacheOperation *> *cacheOperations;


+ (instancetype)sharedInstance;

/**
 * Sets a subclass of `MCDownloadOperation` as the default
 * `NSOperation` to be used each time MCDownload constructs a request
 * operation to download an data.
 *
 * @param operationClass The subclass of `MCDownloadOperation` to set
 *        as default. Passing `nil` will revert to `MCDownloadOperation`.
 */
- (void)setOperationClass:(nullable Class)operationClass;




/// 添加 书籍下载任务
/// @param book 书籍信息
/// @param chapterIds 需要缓存的章节id 数组
/// @param siteId 源id
/// @param progressBlock 缓存过程
/// @param completedBlock 缓存完成
- (nullable BRCacheTask *)cacheChapterContentWithBook:(BRBookInfoModel *)book
                                           chapterIds:(NSArray *)chapterIds
                                               siteId:(NSNumber *)siteId
                                             progress:(nullable BRDataCacheProgressBlock)progressBlock
                                            completed:(nullable BRDataCacheCompletedBlock)completedBlock;


/// 暂停任务
/// @param token 缓存任务有唯一标识
/// @param completed 是否完成任务
- (void)suspended:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed;

/// 恢复任务
/// @param token 缓存任务有唯一标识
/// @param completed 是否完成任务
- (void)resume:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed;


///  取消缓存
/// @param token 缓存书籍的task
/// @param completed 是否完成任务
- (void)cancel:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed;

/// 删除缓存
/// @param token 缓存书籍的task
/// @param completed 是否完成任务
- (void)remove:(nullable BRCacheTask *)token completed:(nullable void (^)(void))completed;
/**
 * Sets the download queue suspension state
 */
- (void)setSuspended:(BOOL)suspended;

/**
 * Cancels all download operations in the queue
 */
- (void)cancelAllDownloads;

/**
 Romove All files in the cache folder.
 @Waring:
 This method is synchronized methods, you should be careful when using, will delete all the data in the cache folder
 */
- (void)removeAndClearAll;


///// 获取所有缓存任务 包括 各种状态下的
//- (NSArray <BRCacheTask *>*)allCacheTask;

- (void)saveAllCacheTask;

@end

NS_ASSUME_NONNULL_END
