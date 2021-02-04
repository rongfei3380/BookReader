//
//  BRChapter.h
//  bookReader
//
//  Created by Jobs on 2020/6/26.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"
#import "BRChapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRChapterDetail : BRBaseModel

/// 小说ID
@property(nonatomic, strong) NSNumber *bookId;
/// 章节id
@property(nonatomic, strong) NSNumber *chapterId;
///  章节名称
@property(nonatomic, strong) NSString *chapterName;
/// 源id
@property(nonatomic, strong) NSNumber *siteId;
/// 源名称
@property(nonatomic, strong) NSString *siteName;
/// 源URL
@property(nonatomic, strong) NSString *siteUrl;
/// 章节内容
@property(nonatomic, strong) NSString *content;

/// 上一章相关
@property(nonatomic, strong) NSString *preChapterName;
@property(nonatomic, strong) NSNumber *preChapterId;

/// 下一章相关属性
@property(nonatomic, strong) NSString *nextChapterName;
@property(nonatomic, strong) NSNumber *nextChapterId;

@property(nonatomic, strong) NSData *time;

/// 获取小说章节内容
/// @param bookId 小说id
/// @param chapterId 章节id
/// @param siteId 源id
/// @param successBlock  章节内容
/// @param failureBlock error
+ (NSURLSessionDataTask *)getChapterContentWithBookId:(NSNumber *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(void(^)(BRChapterDetail *chapterDetail))successBlock
                       failureBlock:(BRObjectFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
