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
//@property(nonatomic, strong) FMDatabase *database;
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
//        self.database = [FMDatabase databaseWithPath:kBRDatabasePath];
        CFDebugLog(@"DB path: %@", kBRDatabasePath);
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:kBRDatabasePath];
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]) {
                //  创建章节内容表
                BOOL creat = [db executeUpdate:kBRDBCreateChapterTextTable];
                if (!creat) {
                    CFDebugLog(@"creat ChapterText Table error:%@",[db lastErrorMessage]);
                }
    //            创建章节列表 表
                creat = [db executeUpdate:kBRDBCreateChapterTable];
                if (!creat) {
                    CFDebugLog(@"creat ChapterList Table error:%@",[db lastErrorMessage]);
                }
                // 创建小说内容表
                
                if (![db tableExists:@"t_book_info"]) {
                    self.needInsertBooks = YES;
                }
    //            需要增加字段的话这里处理
    //            [self.database columnExists:@"" inTableWithName:@"t_book_info"];
                
                creat = [db executeUpdate:kBRDBCreateBookInfoTabel];
                
                if (!creat) {
                    CFDebugLog(@"creat BookInfoTabel Table error:%@",[db lastErrorMessage]);
                }
    //            创建搜索历史表
                creat = [db executeUpdate:kBRDBCreateSearchHistoryTabel];
                if (!creat) {
                    CFDebugLog(@"creat SearchHistoryTabel Table error:%@",[db lastErrorMessage]);
                }
    //            创建阅读历史表
                creat = [db executeUpdate:kBRDBCreateRecordTable];
                if (!creat) {
                    CFDebugLog(@"creat RecordTable Table error:%@",[db lastErrorMessage]);
                }
    //            创建浏览历史表
                creat = [db executeUpdate:kBRDBCreateHistoryBookInfoTabel];
                if (!creat) {
                    CFDebugLog(@"creat HistoryBookInfo Table error:%@",[db lastErrorMessage]);
                }
                [self addTableColumn];
            } else {
                CFDebugLog(@"open database error !!!");
            }
        }];
    }
    return self;
}


/// 用于增加 列  版本变化数据库的处理
- (void)addTableColumn{
    
}

- (void)addDefaultBooks {
    if (self.needInsertBooks) {
        NSDictionary *book1 = @{@"id": @"3788",
            @"name": @"凡人修仙传",
            @"cover":@"https://www.oneoff.net/public/cover/e8/de/d9/e8ded9e57039dea9abf506f46ef7a6d5.jpg",
            @"author": @"忘语",
            @"categoryid": @"3",
            @"lastupdate": @"1600616497",
            @"intro": @"一个普通山村小子，偶然下进入到当地江湖小门派，成了一名记名弟子。他以这样身份，如何在门派中立足,如何以平庸的资质进入到修仙者的行列，从而笑傲三界之中！看凡人修仙传精彩书评集锦，请检索书号：{凡人凡语}新书《魔天记》（3022294）十一月一日将在网站正式上传，请凡人书友及时收藏关注！",
            @"authorid": @"986",
            @"lastchaptername": @"凡人外传仙界篇二",
            @"isover": @"1",
            @"category_name": @"仙侠武侠"};
        NSDictionary *book2 = @{@"id": @"124927",
            @"name": @"如果还能这样爱你",
            @"cover": @"https://www.oneoff.net/public/cover/84/db/64/84db646c4c13849bdd880bb2d1a39888.jpg",
            @"author": @"柠檬",
            @"categoryid": @"13",
            @"lastupdate": @"1600346066",
            @"intro": @"试婚半年，赵斌嫌我某些方面太冷淡，背着我在外面找了个女人。再见面，我挽着他望尘莫及的男人，“亲爱的，这里有只苍蝇。”“你以后不会再见到他。”如愿报复了渣男，却惹上了更大的麻烦，“女人，利用完之后就想一脚踢开，会不会太没有人性？”“人性是什么，能吃吗？”一场意外，我爱上了陆周承，情到浓时，才发现他的心里藏着一个人。在这场毫无胜算的角逐中，我选择主动退出，甚至为了成全他们牺牲了自己的孩子，结果却换来他疯狂的报复。“你是我见过最狠心的女人。”我说：“你也可以选择不见我。”陆周承咬牙切齿的看着我，“想摆脱我，做、梦！”",
            @"authorid": @"34746",
            @"lastchaptername": @"第三百八十二章 以后，将无所畏惧",
            @"isover": @"0",
            @"category_name": @"女生言情"};
        NSDictionary *book3 = @{@"id": @"119040",
            @"name": @"寒门狂婿",
            @"cover": @"https://www.oneoff.net/public/cover/d1/c8/78/d1c878c84830fb0e8d4e088ac48c9d53.jpg",
            @"author": @"黄金战甲",
            @"categoryid": @"31",
            @"lastupdate": @"1600506494",
            @"intro": @"他出身寒门。三年前，为了给父亲买块墓地，穷苦小子徐强甘愿给青山市林家做了上门女婿。三年里，当牛做马，忍辱负重。三年后，得奇遇，一飞冲天。",
            @"authorid": @"83550",
            @"lastchaptername": @"第720章 生于平凡归于平凡（大结局）",
            @"isover": @"0",
            @"category_name": @"综合其他"};
        
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
    
    __block  NSMutableArray *array = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet *result = [db executeQuery:kBRDBSelectBookInfo];
            while ([result next]) {
                BRBookInfoModel *model = [[BRBookInfoModel alloc] initWithFMResult:result];
                if (model) {
                    [array addObject:model];
                }
            }
            [result close];
        }
        [db close];
    }];
    return array;
}

- (void)selectBookInfos:(void(^)(NSArray<BRBookInfoModel*> *books))books {
    kDISPATCH_ON_GLOBAL_QUEUE_LOW(^{
        __block  NSMutableArray *array = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]) {
                FMResultSet *result = [db executeQuery:kBRDBSelectBookInfo];
                while ([result next]) {
                    BRBookInfoModel *model = [[BRBookInfoModel alloc] initWithFMResult:result];
                    if (model) {
                        [array addObject:model];
                    }
                }
                [result close];
            }
            [db close];
        }];
        if(books){
            kdispatch_main_sync_safe(^{
                books(array);
            });
        }
    });
}

- (BRBookInfoModel *)selectBookInfoWithBookId:(NSNumber *)bookId {
    __block BRBookInfoModel *model;
    
   
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:kBRDBSelectBookInfoWithBookId(bookId)];
        if ([result next]) {
            model = [[BRBookInfoModel alloc] initWithFMResult:result];
            [result close];
        }
    }];
    return model;
}

- (void)deleteBookInfoWithBookId:(NSNumber *)bookId {
    if (bookId == nil || (bookId.intValue <= 0)) {
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
    if (bookId == nil || sites == nil || sites.count == 0) {
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

- (BOOL)updateBookUserTimeWithBookId:(NSNumber *)bookId {
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL update = [db executeUpdate:kBRDBUpdateBookUserTime([NSDate date], bookId)];
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

- (BOOL)updateBookSourceWithBookId:(NSNumber *)bookId lastChapterName:(NSString *)lastChapterName lastupdateDate:(NSDate *)lastupdateDate {
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
           if ([db open]) {
               BOOL update = [db executeUpdate:kBRDBUpdateBookLastChapter(lastChapterName, lastupdateDate, bookId)];
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

- (BOOL)updateBookSourceWithBookId:(NSNumber *)bookId bookInfoWithModel:(BRBookInfoModel *)model {
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
           if ([db open]) {
               BOOL update = [db executeUpdate:kBRDBUpdateBookInfoAndLastChapter(model.lastChapterName, model.lastupdateDate, model.cover,model.bookId)];
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

- (void)saveChaptersWithArray:(NSArray<BRChapter*>*)modelsArray bookId:(NSNumber *)bookId{
    
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

- (NSArray<BRChapter*>*)selectChaptersWithBookId:(NSNumber *)bookId siteId:(NSNumber *)siteId{
    __block NSMutableArray* dataArr = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet* result = [db executeQuery:kBRDBSelectChaptersWithSiteIdAndBookId(siteId, bookId)];
              while ([result next]) {
                  BRChapter *model = [[BRChapter alloc] initWithFMResult:result];
                  if (model){
                      [dataArr addObject:model];
                  }
              }
            [result close];
            [db close];
        }
    }];
    return dataArr;
}

/// 查询固定源 下面的章节缓存
/// @param bookId 书籍id
/// @param siteId 源id
- (void)selectChaptersWithBookId:(NSNumber *)bookId siteId:(NSNumber *)siteId chapters:(void(^)(NSArray<BRChapter*>* chapters))chapters {
    __block NSMutableArray* dataArr = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet* result = [db executeQuery:kBRDBSelectChaptersWithSiteIdAndBookId(siteId, bookId)];
              while ([result next]) {
                  BRChapter *model = [[BRChapter alloc] initWithFMResult:result];
                  if (model){
                      [dataArr addObject:model];
                  }
              }
            [result close];
            [db close];
            chapters(dataArr);
        }
    }];
}

#pragma mark- 章节内容

- (BOOL)saveChapterContentWithModel:(BRChapterDetail *)model{
    if (kNumberIsEmpty(model.bookId) || kNumberIsEmpty(model.chapterId)) {
        return NO;
    }
    NSString *uniqueId = [NSString stringWithFormat:@"%@+%@+%@", model.bookId, model.chapterId, model.siteId];
    
    kDISPATCH_ON_GLOBAL_QUEUE_LOW(^(){
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]) {
                BOOL insert = [db executeUpdate:kBRDBInsertChapterText(uniqueId ,model.bookId, model.chapterId, model.chapterName, model.siteId, model.siteName, model.content, model.preChapterId, model.nextChapterId, [NSDate date])];
                if(!insert){
                    CFDebugLog(@"insert BookChapterTextModel url = %@ error:%@",model.chapterName ,[db lastErrorMessage]);
                }
                [db close];
            }
        }];
    });
    return YES;
}

- (void)saveChapterContentWithArray:(NSArray<BRChapterDetail*>*)modelsArray{
    
    kDISPATCH_ON_GLOBAL_QUEUE_LOW((^(){
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]){
                
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    for (BRChapterDetail *model in modelsArray) {
                        NSString *uniqueId = [NSString stringWithFormat:@"%@+%@+%@", model.bookId, model.chapterId, model.siteId];
                        
                        [db executeUpdate:kBRDBInsertChapterText(uniqueId ,model.bookId, model.chapterId, model.chapterName, model.siteId, model.siteName, model.content, model.preChapterId, model.nextChapterId, [NSDate date])];
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
    }));
}

- (BRChapterDetail *)selectChapterContentWithChapterId:(NSNumber *)chapterId bookId:(NSNumber *)bookId siteId:(NSNumber *)siteId {
    
    NSString *uniqueId = [NSString stringWithFormat:@"%@+%@+%@", bookId, chapterId, siteId];
    __block BRChapterDetail* model = nil;
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet* result = [db executeQuery:kBRDBSelectChapterTextWithId(uniqueId)];
        if ([result next]){
            model = [[BRChapterDetail alloc] initWithFMResult:result];
            [result close];
        }

    }];
    return model;
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
    __block NSMutableArray* arr = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet* result = [db executeQuery:kBRDBSelectSearchHistory];
        while ([result next]) {
            [arr addObject:[result stringForColumn:@"book_name"]];
        }
        [result close];
    }];
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
    
    __block BOOL insert = NO;
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
           if ([db open]){
               insert = [db executeUpdate:kBRDBInsertRecord(model.bookId,@(model.chapterIndex),model.recordText,[NSDate date], model.chapterName)];
               
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
    __block BRBookRecord* model = nil;
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet* result = [db executeQuery:kBRDBSelectRecordWithBook_id(bookId)];
            
            if ([result next]){
                model = [[BRBookRecord alloc] initWithFMResult:result];
                [result close];
            }
            [db close];
        }

    }];
    return model;

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
    __block NSMutableArray *array = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:kBRDBSelectHistoryBookInfo];
        while ([result next]) {
            BRBookInfoModel *model = [[BRBookInfoModel alloc] initWithFMResult:result];
            if (model) {
                [array addObject:model];
            }
        }
        [result close];
    }];
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
