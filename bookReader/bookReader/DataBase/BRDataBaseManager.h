//
//  BRDataBaseManager.h
//  bookReader
//
//  Created by Jobs on 2020/6/29.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRBookInfoModel.h"
#import "BRChapterDetail.h"
#import "BRChapter.h"
#import "BRBookRecord.h"


NS_ASSUME_NONNULL_BEGIN

/// 有关书籍的 数据库管理
@interface BRDataBaseManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark- 书本相关
- (void)addDefaultBooks;
/// 保存书本内容
/// @param book 书本对象
- (BOOL)saveBookInfoWithModel:(BRBookInfoModel *)model;

/// 获取全部存储的书籍
- (NSArray<BRBookInfoModel*>*)selectBookInfos;

/// g根据书本id 获取书籍内容
/// @param bookId 书本id
- (BRBookInfoModel *)selectBookInfoWithBookId:(NSNumber *)bookId;

/// 删除指定 书本id 的存储数据
/// @param bookId 书本id
- (void)deleteBookInfoWithBookId:(NSNumber *)bookId;

/// 批量删除图书
/// @param bookIds 图书id 数组
- (void)deleteBookInfoWithBookIds:(NSArray<BRBookInfoModel*> *)bookIds;


/// 更新书本的源信息
/// @param bookId 书本id
/// @param sites 源 数组
/// @param index 当前使用的源
- (BOOL)updateBookSourceWithBookId:(NSNumber *)bookId sites:(NSArray *)sites curSiteIndex:(NSInteger )index;

#pragma mark- 章节信息

/// 保存章节信息
/// @param model 章节
- (BOOL)saveChapterWithModel:(BRChapter *)model;

/// 批量保存章节信息
/// @param modelsArray 章节array
- (void)saveChaptersWithArray:(NSArray<BRChapter*>*)modelsArray bookId:(NSNumber *)bookId;

/// 查询书籍相关的章节缓存
/// @param bookId 书籍id
//- (NSArray<BRChapter*>*)selectChaptersWithBookId:(NSNumber *)bookId;

/// 查询固定源 下面的章节缓存
/// @param bookId 书籍id
/// @param siteId 源id
- (NSArray<BRChapter*>*)selectChaptersWithBookId:(NSNumber *)bookId siteId:(NSNumber *)siteId;


#pragma mark- 章节内容

/// 保存章节内容
/// @param model 章节内容
- (BOOL)saveChapterContentWithModel:(BRChapterDetail *)model;

/// 获取章节id
/// @param chapterId 章节id
- (BRChapterDetail *)selectChapterContentWithChapterId:(NSNumber *)chapterId;

/// 删除章节内容
/// @param chapterId 章节id
- (BOOL)deleteChapterContentWithChapterId:(NSNumber *)chapterId;

/// 删除书本的所有章节内容
/// @param bookId 书本id
- (BOOL)deleteChapterContentWithBookId:(NSNumber *)bookId;

/// 删除 相关书籍 的所有章节内容
/// @param bookIds  书本id 数组
- (void)deleteChapterContentWithBookIds:(NSArray<BRBookInfoModel*> *)bookIds;

#pragma mark- 阅读历史

- (BOOL)saveRecordWithChapterModel:(BRBookRecord*)model;
- (BRBookRecord*)selectBookRecordWithBookId:(NSString*)bookId;
- (void)deleteBookRecordWithBookId:(NSString*)bookId;


#pragma mark- 搜索历史
- (BOOL)saveSearchHistoryWithName:(NSString*)name;
- (NSArray<NSString*>*)selectSearchHistorys;
- (BOOL)deleteSearchWithName:(NSString*)name;
- (void)deleteAllSearch;


- (instancetype)init __attribute__((unavailable("请使用sharedDatabase,以保证该类为单例")));
+ (instancetype)new __attribute__((unavailable("请使用sharedDatabase,以保证该类为单例")));

#pragma mark- 浏览历史

/// 存储 浏览历史的书籍
/// @param model  书籍
- (BOOL)saveHistoryBookInfoWithModel:(BRBookInfoModel *)model;

/// 获取 全部浏览的书籍
- (NSArray<BRBookInfoModel*>*)selectHistoryBookInfos;

/// 清空浏览历史
- (void)deleteHistoryBooksInfo;

@end

NS_ASSUME_NONNULL_END
