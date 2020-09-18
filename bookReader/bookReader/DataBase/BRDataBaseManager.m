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
@property(nonatomic, assign) BOOL needInsertBooks;

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
            
            if (![self.database tableExists:@"t_book_info"]) {
                self.needInsertBooks = YES;
            }
            
            creat = [self.database executeUpdate:kBRDBCreateBookInfoTabel];
            if (!creat) {
                CFDebugLog(@"creat BookInfoTabel Table error:%@",[self.database lastErrorMessage]);
            }
//            创建搜索历史表
            creat = [self.database executeUpdate:kBRDBCreateHistoryBookInfoTabel];
            if (!creat) {
                CFDebugLog(@"creat SearchHistoryTabel Table error:%@",[self.database lastErrorMessage]);
            }
//            创建阅读历史表
            creat = [self.database executeUpdate:kBRDBCreateRecordTable];
            if (!creat) {
                CFDebugLog(@"creat RecordTable Table error:%@",[self.database lastErrorMessage]);
            }
            
            creat = [self.database executeUpdate:kBRDBCreateHistoryBookInfoTabel];
            if (!creat) {
                CFDebugLog(@"creat HistoryBookInfo Table error:%@",[self.database lastErrorMessage]);
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

- (void)addDefaultBooks {
    if (self.needInsertBooks) {
        NSDictionary *book1 = @{@"id": @"27478",
            @"name": @"道君",
            @"cover":@"https://dss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/boxapp_novel/wh%3D267%2C357/sign=5ce401fa9522720e7b9beaf84dfc2675/5bafa40f4bfbfbedfe7792e775f0f736afc31f7f.jpg",
            @"author": @"跃千愁",
            @"categoryid": @"3",
            @"lastupdate": @"1599107872",
            @"intro": @"一个地球神级盗墓宗师，闯入修真界的故事……桃花源里，有歌声。山外青山，白骨山。五花马，千金裘，倚天剑，应我多情，啾啾鬼鸣，美人薄嗔。天地无垠，谁家旗鼓，碧落黄泉，万古高楼。为义气争雄！为乱世争霸！你好，仙侠！作者自定义标签:争霸流",
            @"authorid": @"1221",
            @"lastchaptername": @"新书《前任无双》正式发布",
            @"isover": @"0",
            @"category_name": @"仙侠武侠"};
        NSDictionary *book2 = @{@"id": @"66674",
            @"name": @"剑来",
            @"cover": @"http://www.oneoff.net/public/cover/f2/81/74/f281740604166d7a2ca1c7f0d87a3a1a.jpg",
            @"author": @"烽火戏诸侯",
            @"categoryid": @"1",
            @"lastupdate": @"1599044353",
            @"intro": @"大千世界，无奇不有。我陈平安，唯有一剑，可搬山，倒海，降妖，镇魔，敕神，摘星，断江，摧城，开天！",
            @"authorid": @"31",
            @"lastchaptername": @"第七百九十六章 不浩然",
            @"isover": @"0",
            @"category_name": @"玄幻奇幻"};
        NSDictionary *book3 = @{@"id": @"6865",
            @"name": @"全职高手",
            @"cover": @"https://dss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/boxapp_novel/wh%3D267%2C357/sign=9789368ca81ea8d38a777c06a13d1c7d/faf2b2119313b07e6ef3d13f02d7912397dd8cbf.jpg",
            @"author": @"蝴蝶蓝",
            @"categoryid": @"8",
            @"lastupdate": @"1598965401",
            @"intro": @"网游荣耀中被誉为教科书级别的顶尖高手，因为种种原因遭到俱乐部的驱逐，离开职业圈的他寄身于一家网吧成了一个小小的网管，但是，拥有十年游戏经验的他，在荣耀新开的第十区重新投入了游戏，带着对往昔的回忆，和一把未完成的自制武器，开始了重返巅峰之路。===================================",
            @"authorid": @"5672",
            @"lastchaptername": @"最后一次上传，完本感言。",
            @"isover": @"1",
            @"category_name": @"网游竞技"};
        
        BRBookInfoModel *bookModel1 = [BRBookInfoModel parseDictionaryIntoObject:book1];
        if (![[BRDataBaseManager sharedInstance] selectBookInfoWithBookId:bookModel1.bookId]) {
            [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:bookModel1];
        }
        
        
        BRBookInfoModel *bookModel2 = [BRBookInfoModel parseDictionaryIntoObject:book2];
        [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:bookModel2];
        
        BRBookInfoModel *bookModel3 = [BRBookInfoModel parseDictionaryIntoObject:book3];
        [[BRDataBaseManager sharedInstance] saveBookInfoWithModel:bookModel3];
    }
}

#pragma mark- book info 书本内容

- (BOOL)saveBookInfoWithModel:(BRBookInfoModel *)model {
    if (!model || model.bookId.integerValue <= 0) {
        return NO;
    }
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSArray *sites = model.sitesArray;
            NSString *sitesString = [sites yy_modelToJSONString];
            NSData *encodeData = [sitesString dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
            
            
            BOOL insert = [db executeUpdate:kBRDBInsertBookInfo(model.bookName, model.bookId, model.cover, model.author, model.authorId, model.categoryId, model.categoryName, model.lastupdate, model.intro, model.desc, model.lastChapterName, [NSDate date], base64String, model.siteIndex)];
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
            
            BOOL update = [db executeUpdate:kBRDBUpdateBookSource(base64String, [NSNumber numberWithInteger:index], bookId)];
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

- (void)deleteChapterContentWithBookIds:(NSArray<BRBookInfoModel*> *)bookIds {
    kDISPATCH_ON_GLOBAL_QUEUE_HIGH(^(){
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]){
                
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    for (BRChapter *model in bookIds) {
                        NSNumber *bookId = model.bookId;
                        [db executeUpdate:kBRDBDeleteChapterTextWithBookId(bookId)];
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

- (BOOL)deleteChapterContentWithOtherBooks {
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]){
            FMResultSet* result = [db executeQuery:kBRDBDeleteChapterTextOtherBooks];
            NSMutableArray *bookIds = [[NSMutableArray alloc] init];
            while ([result next]){
                NSNumber *bookId = [NSNumber numberWithInteger:[result stringForColumn:@"book_id"].integerValue];
                [bookIds addObject:bookId];
            }
           [result close];
            
            for (NSNumber *bookId in bookIds) {
                BOOL del = [db executeUpdate:kBRDBDeleteChapterTextWithBookId(bookId)];
                if (!del){
                    CFDebugLog(@"delete chapter_text  error:%@",[db lastErrorMessage]);
                }
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

#pragma mark- 浏览历史

/// 存储 浏览历史的书籍
/// @param model  书籍
- (BOOL)saveHistoryBookInfoWithModel:(BRBookInfoModel *)model {
    if (!model || model.bookId.integerValue <= 0) {
           return NO;
       }
       [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
           if ([db open]) {
               NSArray *sites = model.sitesArray;
               NSString *sitesString = [sites yy_modelToJSONString];
               NSData *encodeData = [sitesString dataUsingEncoding:NSUTF8StringEncoding];
               NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
               
               
               BOOL insert = [db executeUpdate:kBRDBInsertHistoryBookInfo(model.bookName, model.bookId, model.cover, model.author, model.authorId, model.categoryId, model.categoryName, model.lastupdate, model.intro, model.desc, model.lastChapterName, [NSDate date], base64String, model.siteIndex)];
               if (!insert) {
                   CFDebugLog(@"insert bookInfoModel book_name = %@, error:%@", model.bookName, [db lastErrorMessage]);
               }
           }
       }];
       return YES;
}

/// 获取 全部浏览的书籍
- (NSArray<BRBookInfoModel*>*)selectHistoryBookInfos {
    FMResultSet *result = [self.database executeQuery:kBRDBSelectHistoryBookInfo];
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

/// 清空浏览历史
- (void)deleteHistoryBooksInfo {
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL delete = [db executeUpdate:kBRDBDeleteHistoryBooksInfo];
            if (!delete) {
                   NSLog(@"delete History BookInfoModel  error:%@", [db lastErrorMessage]);
            }
        }
        [db close];
    }];
}

@end
