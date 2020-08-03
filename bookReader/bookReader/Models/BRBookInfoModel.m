//
//  BRBookInfoModel.m
//  bookReader
//
//  Created by Jobs on 2020/6/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookInfoModel.h"
#import "BRAPIClient.h"


@implementation BRBookInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"bookName":@"name",
             @"bookId":@"id",
             @"cover":@"cover",
             @"author":@"author",
             @"categoryId":@"categoryid",
             @"lastupdate":@"lastupdate",
             @"introintrointrointro":@"intro",
             @"authorId":@"authorid",
             @"otherBooks":@"list",
             @"categoryName":@"category_name",
             @"desc":@"caption",
             @"isOver":@"isover",
             @"lastChapterId":@"lastChapterId",
             @"lastChapterName":@"lastchaptername"
    };
}
+ (nullable NSDictionary*)modelContainerPropertyGenericClass {
    return @{
        @"list" : [BRBookInfoModel class],
    };
}

+ (id)parseDictionaryIntoObject:(NSDictionary *)dic {
    BRBookInfoModel *item = [[BRBookInfoModel alloc] initWithAttributes:dic];
    item.lastupdateDate = [NSDate dateWithTimeIntervalSince1970:item.lastupdate.integerValue];
    if ([dic objectForKey:@"list"]) {
        item.otherBooks = [BRBookInfoModel parseDictionaryIntoRecords:[dic objectForKey:@"list"]];
    }
    return item;
}


+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody {
    NSMutableArray *ret = [NSMutableArray array];
    if ([dataBody isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = (NSDictionary *)dataBody;
        
        // 如果有多个用户的话
        if ([[dataDic allKeys] containsObject:@"expressions"]) {
            NSArray *usersDicArray = (NSArray *)[dataDic objectForKey:@"expressions"];
            for (NSDictionary *dic in usersDicArray) {
                [ret addObject:[BRBookInfoModel parseDictionaryIntoObject:dic]];
            }
        } else {
            [ret addObject:[BRBookInfoModel parseDictionaryIntoObject:dataDic]];
        }
    } else if ([dataBody isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in dataBody) {
            [ret addObject:[BRBookInfoModel parseDictionaryIntoObject:dic]];
        }
    }
    return [NSArray arrayWithArray:ret];
}

#pragma mark- API

+ (void)getbookinfoWithBookId:(NSInteger)bookid
                     isSelect:(BOOL)isSelect
                       sucess:(void(^)(BRBookInfoModel *bookInfo))successBlock
                 failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getbookinfoWithBookId:bookid isSelect:isSelect sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            BRBookInfoModel *item = [BRBookInfoModel parseDictionaryIntoObject:dataBody];
            successBlock(item);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (void)getBookListWithCategory:(NSInteger)categoryId
                           page:(NSInteger)page
                           size:(NSInteger)size
                         sucess:(BRObjectSuccessBlock)successBlock
                   failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getBookListWithCategory:categoryId page:page size:size sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRBookInfoModel parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (void)searchBookWithName:(NSString *)name
                      page:(NSInteger)page
                      size:(NSInteger)size
                    sucess:(BRObjectSuccessBlock)successBlock
              failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] searchBookWithName:name page:page size:size sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRBookInfoModel parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (void)getRecommendSuccess:(void(^)(NSArray *rotationArray, NSArray *recommendArray))successBlock
               failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getRecommendSuccess:^(id  _Nonnull dataBody) {
        NSDictionary *dict = (NSDictionary *)dataBody;
        
        NSArray *recommend = [BRBookInfoModel parseDictionaryIntoRecords:[dict objectForKey:@"recommend"]];
        NSArray *rotation = [BRBookInfoModel parseDictionaryIntoRecords:[dict objectForKey:@"rotation"]];
        successBlock(rotation, recommend);
        
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)getRankListWithType:(NSInteger)type
                       page:(NSInteger)page
                       size:(NSInteger)size
                    success:(BRObjectSuccessBlock)successBlock
               failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getRankListWithType:type page:page size:size success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRBookInfoModel parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)getBookInfosShelfWithBookids:(NSString *)ids
                              sucess:(BRObjectSuccessBlock)successBlock
                        failureBlock:(BRObjectFailureBlock)failureBlock {
    
    [[BRAPIClient sharedInstance] getBookInfosShelfWithBookids:ids sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRBookInfoModel parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
