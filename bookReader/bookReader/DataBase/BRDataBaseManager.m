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
#import "BRChapter+database.h"
#import "BRBookRecord+database.h"
#import "BRChapterDetail+database.h"

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
    if (!bookId || (bookId.intValue <= 0)) {
        return;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL delete = [db executeUpdate:kBRDBDeleteBookInfo(bookId)];
            if (!delete) {
                NSLog(@"delete BookInfoModel bookId = %@ error:%@",bookId, [db lastErrorMessage]);
            }
        }
        [db close];
    }];
}

 - (void)deleteBookInfoWithBookIds:(NSArray<BRBookInfoModel*> *)bookIds {
    kDISPATCH_ON_GLOBAL_QUEUE_HIGH(^(){
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]){
                
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    for (BRChapter *model in bookIds) {
                        NSNumber *bookId = model.bookId;
                        [db executeUpdate:kBRDBDeleteBookInfo(bookId)];
                    }
                } @catch (NSException *exception) {
                    isRollBack = YES;
                    [db rollback];
                } @finally {
                    if (!isRollBack) {
                        [db commit];
                    }
                }
            }
            [db close];
        }];
    });
}


- (BOOL)updateBookSourceWithBookId:(NSNumber *)bookId sites:(NSArray *)sites curSiteIndex:(NSInteger )index{
    if (!bookId || !sites || sites.count == 0) {
        return NO;
    }
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSString *sitesString = [sites yy_modelToJSONString];
            NSData *encodeData = [sitesString dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
            
            BOOL update = [db executeUpdate:kBRDBUpdateBookSource(base64String, index, bookId)];
            if(!update) {
                CFDebugLog(@"update BookInfoModel sits bookId = %@ error:%@",bookId, [db lastErrorMessage]);
            }
        } else {
            CFDebugLog(@"update BookInfoModel sits bookId = %@ error:%@",bookId, [db lastErrorMessage]);
        }
        [db close];
    }];
    return YES;
}

#pragma mark- 章节信息

- (BOOL)saveChapterWithModel:(BRChapter *)model{
    if (kNumberIsEmpty(model.bookId) || kNumberIsEmpty(model.chapterId)){
        CFDebugLog(@"章节信息保存错误:%@",model);
        return NO;
    }
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL insert = [db executeUpdate:kBRDBInsertChapter(model.bookId, model.chapterId, model.name, model.siteId, model.siteName, model.time)];
        if (!insert) {
            CFDebugLog(@"insert BRChapter name = %@ error:%@",model.name,[db lastErrorMessage]);
        }
    }];
    
    
    return YES;
}

- (void)saveChaptersWithArray:(NSArray<BRChapterDetail*>*)modelsArray bookId:(NSNumber *)bookId{
    
    kDISPATCH_ON_GLOBAL_QUEUE_HIGH(^(){
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]){
                
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    for (BRChapter *model in modelsArray) {
                        [db executeUpdate:kBRDBInsertChapter(bookId, model.chapterId, model.name, model.siteId, model.siteName, model.time)];
                    }
                } @catch (NSException *exception) {
                    isRollBack = YES;
                    [db rollback];
                } @finally {
                    if (!isRollBack) {
                        [db commit];
                    }
                }
            }
            [db close];
        }];
    });
}

- (NSArray<BRChapterDetail*>*)selectChaptersWithBookId:(NSNumber *)bookId {
    return [NSArray array];
}

/// 查询固定源 下面的章节缓存
/// @param bookId 书籍id
/// @param siteId 源id
- (NSArray<BRChapter*>*)selectChaptersWithBookId:(NSNumber *)bookId siteId:(NSNumber *)siteId {
     FMResultSet* result = [self.database executeQuery:kBRDBSelectChaptersWithSiteIdAndBookId(siteId, bookId)];
       
       NSMutableArray* dataArr = [NSMutableArray array];
       
       while ([result next]) {
           BRChapter *model = [[BRChapter alloc] initWithFMResult:result];
           if (model){
               [dataArr addObject:model];
           }
       }
       [result close];
       return dataArr;
}

#pragma mark- 章节内容

- (BOOL)saveChapterContentWithModel:(BRChapterDetail *)model{
    if (kNumberIsEmpty(model.bookId) || kNumberIsEmpty(model.chapterId)) {
        return NO;
    }
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL insert = [db executeUpdate:kBRDBInsertChapterText(model.bookId, model.chapterId, model.chapterName, model.siteId, model.siteName, model.content, model.preChapterId, model.nextChapterId, [NSDate date])];
            if(!insert){
                CFDebugLog(@"insert BookChapterTextModel url = %@ error:%@",model.chapterName ,[db lastErrorMessage]);
            }
            [db close];
        }
    }];
    
    return YES;
}


- (BRChapterDetail *)selectChapterContentWithChapterId:(NSNumber *)chapterId {
    FMResultSet* result = [self.database executeQuery:kBRDBSelectChapterTextWithId(chapterId)];
    
    if ([result next]){
        BRChapterDetail* model = [[BRChapterDetail alloc] initWithFMResult:result];
        [result close];
        return model;
    }
    
    return nil;

}

- (BOOL)deleteChapterContentWithChapterId:(NSNumber *)chapterId{
    if (kNumberIsEmpty(chapterId))
           return NO;
       
       [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
           if ([db open]){
               BOOL del = [db executeUpdate:kBRDBDeleteChapterTextWithId(chapterId)];
               if (!del){
                   CFDebugLog(@"delete chapter_text where chapterId = %@ error:%@",chapterId,[db lastErrorMessage]);
               }
           }
           [db close];
       }];
       
       return YES;
}

- (BOOL)deleteChapterContentWithBookId:(NSNumber *)bookId {
    if (kNumberIsEmpty(bookId))
        return NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL del = [db executeUpdate:kBRDBDeleteChapterTextWithBookId(bookId)];
            if (!del){
                CFDebugLog(@"delete chapter_text where book_id = %@ error:%@",bookId,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}



#pragma mark- 搜索历史

- (BOOL)saveSearchHistoryWithName:(NSString*)name {
    if (kStringIsEmpty(name))
        return NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            BOOL insert = [db executeUpdate:kBRDBInsertSearchHistory(name, [NSDate date])];
            if (!insert){
                CFDebugLog(@"insert SearchHistory name = %@ error:%@",name,[db lastErrorMessage]);
            }
        }
        [db close];
    }];
    
    return YES;
}

- (NSArray<NSString*>*)selectSearchHistorys {
    FMResultSet* result = [self.database executeQuery:kBRDBSelectSearchHistory];
    
    NSMutableArray* arr = [NSMutableArray array];
    
    while ([result next]) {
        [arr addObject:[result stringForColumn:@"book_name"]];
    }
    
    [result close];
    return arr;
}

- (BOOL)deleteSearchWithName:(NSString*)name {
    if (kStringIsEmpty(name))
           return NO;
       
       [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
           if ([db open]){
               BOOL dele = [db executeUpdate:kBRDBDeleteSearchHistoryWithName(name)];
               if (!dele){
                   CFDebugLog(@"delete SearchHistory name = %@ error:%@",name,[db lastErrorMessage]);
               }
           }
           [db close];
       }];
       
       return YES;
}

- (void)deleteAllSearch {
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            [db executeUpdate:kBRDBDeleteAllHistory];
        }
        [db close];
    }];
}


#pragma mark- 阅读历史

- (BOOL)saveRecordWithChapterModel:(BRBookRecord*)model {
    if (kNumberIsEmpty(model.bookId) || kStringIsEmpty(model.recordText)){
        return NO;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
           if ([db open]){
               BOOL insert = [db executeUpdate:kBRDBInsertRecord(model.bookId,@(model.chapterIndex),model.recordText,[NSDate date], model.chapterName)];
               
               insert = [db executeUpdate:kBRDBUpdateBookUserTime([NSDate date], model.bookId)];
               
               if(!insert){
                   CFDebugLog(@"insert BookRecordModel book_id = %@ error:%@",model.bookId,[db lastErrorMessage]);
               }
           }
           [db close];
       }];
    
    return YES;
}

- (BRBookRecord*)selectBookRecordWithBookId:(NSString*)bookId {
    FMResultSet* result = [self.database executeQuery:kBRDBSelectRecordWithBook_id(bookId)];
    
    if ([result next]){
        BRBookRecord* model = [[BRBookRecord alloc] initWithFMResult:result];
        [result close];
        if (model){
            return model;
        }
    }
    return nil;

}
//
//- (void)deleteBookRecordWithBookId:(NSString*)bookId {
//
//}

@end
