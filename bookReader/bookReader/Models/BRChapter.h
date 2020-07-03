//
//  BRChapter.h
//  bookReader
//
//  Created by Jobs on 2020/6/26.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRChapter : BRBaseModel

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
@property(nonatomic, strong) NSString *preChapterId;

/// 下一章相关属性
@property(nonatomic, strong) NSString *nextChapterName;
@property(nonatomic, strong) NSString *nextChapterId;




/// 小说章节列表
/// @param bookId 书籍id
/// @param siteId 源id
/// @param sortType  章节排序,asc:升序,desc:降序  1 升序 0 降序
/// @param successBlock 小说章节列表
/// @param failureBlock  error
+ (void)getChaptersListWithBookId:(NSString *)bookId
                           siteId:(NSInteger)siteId
                         sortType:(NSInteger)sortType
                           sucess:(BRObjectSuccessBlock)successBlock
                     failureBlock:(BRObjectFailureBlock)failureBlock;


/// 获取小说章节内容
/// @param bookId 小说id
/// @param chapterId 章节id
/// @param siteId 源id
/// @param successBlock  章节内容
/// @param failureBlock error
+ (void)getChapterContentWithBookId:(NSString *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(void(^)(BRChapter *chapter))successBlock
                       failureBlock:(BRObjectFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
