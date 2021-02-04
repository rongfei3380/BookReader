//
//  BRCacheModel.h
//  bookReader
//
//  Created by Jobs on 2020/12/27.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 用来处理章节缓存的数据model
@interface BRCacheTask : BRBaseModel

/// 缓存章节的 书名
@property(nonatomic, strong) NSString *bookName;
/// 缓存章节的 所属书记id
@property(nonatomic, strong) NSString *bookId;
/// 缓存章节的 所属书籍的封面
@property(nonatomic, strong) NSString *cover;
/// 缓存章节  目标章节数
@property(nonatomic, strong) NSNumber *totalChapters;
/// 缓存章节  已完成章节数
@property(nonatomic, strong) NSNumber *cachedChapters;
/// 缓存章节  任务状态   0 暂停 1 进行中 2 取消
@property(nonatomic, strong) NSNumber *status;

@end

NS_ASSUME_NONNULL_END
