//
//  BRChapterContent.h
//  bookReader
//
//  Created by Jobs on 2020/7/19.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"


NS_ASSUME_NONNULL_BEGIN

/// 列表用的章节 对象
@interface BRChapter : BRBaseModel

/// 章节名称
@property(nonatomic, strong) NSString *name;
/// 章节id  不同源 章节id可能不同
@property(nonatomic, strong) NSNumber *chapterId;
/// 章节所属小说id
@property(nonatomic,copy) NSNumber *bookId;
/// 源id
@property(nonatomic,copy) NSNumber *siteId;
/// 源 名称
@property(nonatomic,copy) NSString *siteName;

@property(nonatomic,copy) NSNumber *time;
/// 章节内容 主要用于章节缓存查询
@property(nonatomic, strong) NSString *chapterText;

/// 小说章节列表
/// @param bookId 书籍id
/// @param siteId 源id
/// @param sortType  章节排序,asc:升序,desc:降序  1 升序 0 降序
/// @param successBlock 小说章节列表
/// @param failureBlock  error
+ (NSURLSessionDataTask *)getChaptersListWithBookId:(NSNumber *)bookId
                           siteId:(NSInteger)siteId
                         sortType:(NSInteger)sortType
                           sucess:(BRObjectSuccessBlock)successBlock
                     failureBlock:(BRObjectFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
