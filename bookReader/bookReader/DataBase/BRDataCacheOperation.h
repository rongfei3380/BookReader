//
//  BRDataCacheOperation.h
//  bookReader
//
//  Created by Jobs on 2021/1/9.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRCacheTask.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * _Nonnull const BRCacheStartNotification;
extern NSString * _Nonnull const BRCacheReceiveResponseNotification;
extern NSString * _Nonnull const BRCacheStopNotification;
extern NSString * _Nonnull const BRCacheFinishNotification;



@protocol BRDataCacheOperationInterface<NSObject>

- (nonnull instancetype)initWithCacheTask:(nullable BRCacheTask *)cacheTask;

- (nullable id)addHandlersForProgress:(nullable BRDataCacheProgressBlock)progressBlock
                            completed:(nullable BRDataCacheCompletedBlock)completedBlock;

@end

@interface BRDataCacheOperation : NSOperation<BRDataCacheOperationInterface>

@property(nonatomic, assign) BOOL suspended;

- (nonnull instancetype)initWithCacheTask:(nullable BRCacheTask *)cacheTask;

- (nullable id)addHandlersForProgress:(nullable BRDataCacheProgressBlock)progressBlock
                            completed:(nullable BRDataCacheCompletedBlock)completedBlock;

- (BOOL)cancel:(nullable id)token;
- (BOOL)suspended:(nullable id)token;

@end

NS_ASSUME_NONNULL_END
