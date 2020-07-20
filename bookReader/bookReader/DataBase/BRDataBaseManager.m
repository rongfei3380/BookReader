//
//  BRDataBaseManager.m
//  bookReader
//
//  Created by Jobs on 2020/6/29.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRDataBaseManager.h"
#import "BRDatabaseMacros.h"
#import "CFCustomMacros.h"
#import <FMDB/FMDB.h>

#import "BRBookInfoModel+database.h"


@interface BRDataBaseManager()

@property(nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property(nonatomic, strong) FMDatabase *database;

@end


@implementation BRDataBaseManager

+ (instancetype)sharedInstance{
    static BRDataBaseManager *dataBase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBase = [[BRDataBaseManager alloc] initDataBase];
    });
    return dataBase;
}

/// 初始化数据库 创建表
- (instancetype)initDataBase {
    self = [super init];
    if (self) {
        self.database = [FMDatabase databaseWithPath:kBRDatabasePath];
        CFDebugLog(@"DB path: %@", kBRDatabasePath);
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:kBRDatabasePath];
        if ([self.database open]) {
            //  创建章节内容表
            BOOL creat = [self.database executeUpdate:kBRDBCreateChapterTextTable];
            if (!creat) {
                CFDebugLog(@"creat ChapterText Table error:%@",[self.database lastErrorMessage]);
            }
//            创建章节列表 表
            creat = [self.database executeUpdate:kBRDBCreateChapterTable];
            if (!creat) {
                CFDebugLog(@"creat ChapterList Table error:%@",[self.database lastErrorMessage]);
            }
            // 创建小说内容表
            creat = [self.database executeUpdate:kBRDBCreateBookInfoTabel];
            if (!creat) {
                CFDebugLog(@"creat BookInfoTabel Table error:%@",[self.database lastErrorMessage]);
            }
//            创建搜索历史表
            creat = [self.database executeUpdate:kBRDBCreateSearchHistoryTabel];
            if (!creat) {
                CFDebugLog(@"creat SearchHistoryTabel Table error:%@",[self.database lastErrorMessage]);
            }
//            创建阅读历史表
            creat = [self.database executeUpdate:kBRDBCreateRecordTable];
            if (!creat) {
                CFDebugLog(@"creat RecordTable Table error:%@",[self.database lastErrorMessage]);
            }
            
            [self addTableColumn];
            
        } else {
            CFDebugLog(@"open database error !!!");
        }
    }
    
    return self;
}


/// 用于增加 列  版本变化数据库的处理
- (void)addTableColumn{
    
}

#pragma mark- book info 书本内容

- (BOOL)saveBookInfoWithModel:(BRBookInfoModel *)model {
    if (!model) {
        return NO;
    }
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL insert = [db executeUpdate:kBRDBInsertBookInfo(model.bookName, model.bookId, model.cover, model.author, model.authorId, model.categoryId, model.categoryName, model.lastupdate, model.intro, model.desc, [NSDate date])];
            if (!insert) {
                CFDebugLog(@"insert bookInfoModel book_name = %@, error:%@", model.bookName, [db lastErrorMessage]);
            }
        }
    }];
    return YES;
}

- (NSArray<BRBookInfoModel*>*)selectBookInfos {
    FMResultSet *result = [self.database executeQuery:kBRDBSelectBookInfo];
    NSMutableArray *array = [NSMutableArray array];
    while ([result next]) {
        BRBookInfoModel *model = [[BRBookInfoModel alloc] initWithFMResult:result];
        if (model) {
            [array addObject:model];
        }
    }
    [result close];
    return array;
    
}

- (BRBookInfoModel *)selectBookInfoWithBookId:(NSNumber *)bookId {
    FMResultSet *result = [self.database executeQuery:kBRDBSelectBookInfoWithBookId(bookId)];
    if ([result next]) {
        BRBookInfoModel *model = [[BRBookInfoModel alloc] initWithFMResult:result];
        [result close];
        return model;
    }
    return nil;
}

- (void)deleteBookInfoWithBookId:(NSNumber *)bookId {
    if (!bookId || !(bookId <= 0)) {
        return;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL delete = [db executeUpdate:kBRDBDeleteBookInfo(bookId)];
            if (!delete) {
                CFDebugLog(@"delete BookInfoModel bookId = %@ error:%@",bookId, [db lastErrorMessage]);
            }
        }
        [db close];
    }];
}

#pragma mark- 章节信息

- (BOOL)saveChapterWithModel:(BRChapterDetail *)model{
//    if (kNumberIsEmpty(model.bookId) || kStringIsEmpty(model.record_text)){
        return NO;
//    }
}

- (void)saveChaptersWithArray:(NSArray<BRChapterDetail*>*)modelsArray bookId:(NSNumber *)bookId{
    
//    kDISPATCH_ON_GLOBAL_QUEUE_HIGH(^(){
//        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
//            if ([db open]){
//                
//                [db beginTransaction];
//                BOOL isRollBack = NO;
//                @try {
//                    for (BRChapterDetail* model in modelsArray) {
//                        [db executeUpdate:kBRDBInsertChapter(bookId, model.chapterId, model.chapterName, model.siteId, model.siteName, model.siteUrl, model.preChapterId, model.nextChapterId, [NSData data])];
//                    }
//                } @catch (NSException *exception) {
//                    isRollBack = YES;
//                    [db rollback];
//                } @finally {
//                    if (!isRollBack) {
//                        [db commit];
//                    }
//                }
//                
//            }
//            [db close];
//        }];
//    });
}

- (NSArray<BRChapterDetail*>*)selectChaptersWithBookId:(NSNumber *)bookId {
    return [NSArray array];
}

/// 查询固定源 下面的章节缓存
/// @param bookId 书籍id
/// @param siteId 源id
- (NSArray<BRChapterDetail*>*)selectChaptersWithBookId:(NSNumber *)bookId SiteId:(NSNumber *)siteId {
    return [NSArray array];
}

//- (BOOL)updateBookSourceWithRelatedId:(NSString*)relatedId Name:(NSString*)name SourceUrl:(NSString*)sourceUrl {
//
//}
//
//
//#pragma mark- 章节信息
//- (BOOL)saveChapterWithModel:(BRChapter *)model{
//
//}
//
//- (void)saveChaptersWithArray:(NSArray<BRChapter*>*)modelsArray {
//
//}
//
//- (NSArray<BRChapter*>*)selectChaptersWithSiteId:(NSNumber *)siteId {
//
//}
//
//#pragma mark- 章节内容
//- (void)saveChapterContentWithModel:(BRChapterContent *)model {
//
//}
//
//- (BRChapterContent *)selectChapterContentWithChapterId:(NSNumber *)chapterId {
//
//}
//
//- (BOOL)deleteChapterContentWithChapterId:(NSNumber *)chapterId {
//
//}
//
//- (BOOL)deleteChapterContentWithBookId:(NSNumber *)bookId {
//
//}



#pragma mark- 搜索历史

#pragma mark- 阅读历史

@end
