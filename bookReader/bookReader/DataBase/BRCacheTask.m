//
//  BRCacheModel.m
//  bookReader
//
//  Created by Jobs on 2020/12/27.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRCacheTask.h"

@interface BRCacheTask ()

@property(nonatomic, strong) NSMutableArray <NSNumber *>*chapterIds;

@end

@implementation BRCacheTask
@synthesize chapterIds = _chapterIds;
@synthesize toCacheChapterIds = _toCacheChapterIds;
@synthesize state = _state;
//@synthesize cachedChapterIds = _cachedChapterIds;


- (instancetype)initWithBookId:(nonnull NSNumber *)bookId
                      bookName:(NSString *)bookName
                         cover:(NSString *)cover
                     chapterIds:(NSArray <NSNumber *> *)chapterIds
                        siteId:(NSNumber *)siteId
     cacheOperationCancelToken:(nullable id)cacheOperationCancelToken
            cacheProgressBlock:(nullable BRDataCacheProgressBlock)cacheProgressBlock
           cacheCompletedBlock:(nullable BRDataCacheCompletedBlock)cacheCompletedBlock {
    if (self = [self init]) {
        self.bookId = bookId;
        self.bookName = bookName;
        self.cover = cover;
        _chapterIds = [self allChapterIdsSet:chapterIds];
        _toCacheChapterIds = [chapterIds mutableCopy];
        _cachedChapterIds = [NSMutableArray array];
        self.siteId = siteId;
        self.taskOperationCancelToken = cacheOperationCancelToken;
        self.cacheProgressBlock = cacheProgressBlock;
        self.cacheCompletedBlock = cacheCompletedBlock;
        
    }
    return self;
}

- (NSMutableArray <NSNumber *> *)allChapterIdsSet:(NSArray <NSNumber *> *)chapterIds {
    NSMutableSet *sourcesChapterIdsSet = [NSMutableSet setWithArray:_chapterIds];
    NSMutableSet *addChapterIdsSet = [NSMutableSet setWithArray:chapterIds];
    [sourcesChapterIdsSet unionSet:addChapterIdsSet];
    
    _chapterIds = [NSMutableArray arrayWithArray:[sourcesChapterIdsSet allObjects]];
    return _chapterIds;
}

- (NSMutableArray <NSNumber *> *)addCacheChapterIds:(NSArray <NSNumber *> *)chapterIds {
    
    _chapterIds = [self allChapterIdsSet:chapterIds];
    
    NSMutableSet *toCacheChapterIdsSet = [NSMutableSet setWithArray:chapterIds];
    NSMutableSet *cachedChapterIdsSet = [NSMutableSet setWithArray:_cachedChapterIds];

    [toCacheChapterIdsSet minusSet:cachedChapterIdsSet];
    if (!_toCacheChapterIds) {
        _toCacheChapterIds = [NSMutableArray array];
    }
    NSMutableSet *lastToCacheChapterIdsSet = [NSMutableSet setWithArray:_toCacheChapterIds];
    [toCacheChapterIdsSet minusSet:lastToCacheChapterIdsSet];
    
    [_toCacheChapterIds addObjectsFromArray:[toCacheChapterIdsSet allObjects]];
    return _toCacheChapterIds;
}

- (NSInteger)allChapterCount {
    return _chapterIds.count;
}

#pragma mark-- setter
- (void)setCacheProgressBlock:(BRDataCacheProgressBlock _Nullable)cacheProgressBlock {
    _cacheProgressBlock = cacheProgressBlock;
}

- (void)setCacheCompletedBlock:(BRDataCacheCompletedBlock _Nullable)cacheCompletedBlock {
    _cacheCompletedBlock = cacheCompletedBlock;
}

- (void)setState:(BRCacheTaskState)state {
    _state = state;
    _cacheState = [NSNumber numberWithInteger:state];
}

- (void)setTaskOperationCancelToken:(id _Nullable)taskOperationCancelToken {
    _taskOperationCancelToken = taskOperationCancelToken;
}

- (BRCacheTaskState)state {
    _state = _cacheState.integerValue;
    return _state;
}

#pragma mark- private
- (NSInteger)countOfTotalCountExpectedToCache {
    return self.chapterIds.count;
}

@end
