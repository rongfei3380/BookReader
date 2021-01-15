//
//  BRCacheModel.h
//  bookReader
//
//  Created by Jobs on 2020/12/27.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"
@class BRDataCacheOperation;

NS_ASSUME_NONNULL_BEGIN

@class BRCacheTask;
/** The download state */
typedef NS_ENUM(NSUInteger, BRCacheTaskState) {
    BRCacheTaskStateNone,           /** default */
    BRCacheTaskStateWillResume,     /** waiting */
    BRCacheTaskStateDownloading,    /** downloading */
    BRCacheTaskStateSuspened,       /** suspened */
    BRCacheTaskStateCompleted,      /** download completed */
    BRCacheTaskStateFailed          /** download failed */
};

/** The download prioritization */
typedef NS_ENUM(NSInteger, BRCachePrioritization) {
    BRCachePrioritizationFIFO,  /** first in first out */
    BRCachePrioritizationLIFO   /** last in first out */
};

typedef void (^BRDataCacheProgressBlock)(NSInteger receivedCount, NSInteger expectedCount, BRCacheTask * _Nullable task);

typedef void (^BRDataCacheCompletedBlock)(BRCacheTask * _Nullable task, NSError * _Nullable error, BOOL finished);

/// 用来处理章节缓存的数据model
@interface BRCacheTask : BRBaseModel

/// 缓存章节的 书名
@property(nonatomic, strong) NSString *bookName;
/// 缓存章节的 所属书籍的封面
@property(nonatomic, strong) NSString *cover;

/// 缓存章节的 所属书记id
@property(nonatomic, strong) NSNumber *bookId;
/// 缓存章节 的源id
@property(nonatomic, strong) NSNumber *siteId;

/**
 * Download State
 */
@property (nonatomic, assign) BRCacheTaskState state;

@property (nonatomic, strong) NSNumber* cacheState;


/// 已缓存章节id
@property(nonatomic, strong) NSMutableArray <NSNumber *>*cachedChapterIds;
/// 未缓存章节id
@property(nonatomic, strong) NSMutableArray <NSNumber *>*toCacheChapterIds;


@property (nonatomic, strong, readonly, nullable) NSError *error;

@property (nonatomic, strong, nullable) id taskOperationCancelToken;


/**
 The call back block. When setting this block，the progress block will be called during downloading，the complete block will be called after download finished.
 */
@property (nonatomic,copy, nullable, readonly)BRDataCacheProgressBlock cacheProgressBlock;
@property (nonatomic,copy, nullable, readonly)BRDataCacheCompletedBlock cacheCompletedBlock;
@property (nonatomic, strong, nullable) id cacheOperationCancelToken;

- (void)setState:(BRCacheTaskState)state;
- (void)setTaskOperationCancelToken:(id _Nullable)taskOperationCancelToken;
- (void)setCacheProgressBlock:(BRDataCacheProgressBlock _Nullable)cacheProgressBlock;
- (void)setCacheCompletedBlock:(BRDataCacheCompletedBlock _Nullable)cacheCompletedBlock;

#pragma mark- prvite

/// 构造一个下载任务
/// @param bookId 书籍id
/// @param bookName 书籍名称
/// @param cover 封面
/// @param chapterIds 待下载的章节id
/// @param siteId 源id
/// @param cacheOperationCancelToken 取消的token
/// @param cacheProgressBlock 缓存过程
/// @param cacheCompletedBlock 完成缓存的block
- (instancetype)initWithBookId:(nonnull NSNumber *)bookId
                      bookName:(NSString *)bookName
                         cover:(NSString *)cover
                     chapterIds:(NSArray <NSNumber *> *)chapterIds
                        siteId:(NSNumber *)siteId
     cacheOperationCancelToken:(nullable id)cacheOperationCancelToken
            cacheProgressBlock:(nullable BRDataCacheProgressBlock)cacheProgressBlock
           cacheCompletedBlock:(nullable BRDataCacheCompletedBlock)cacheCompletedBlock;

- (NSMutableArray <NSNumber *> *)addCacheChapterIds:(NSArray <NSNumber *> *)chapterIds;

- (NSInteger)allChapterCount;

@end

NS_ASSUME_NONNULL_END
