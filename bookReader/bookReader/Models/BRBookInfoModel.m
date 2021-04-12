//
//  BRBookInfoModel.m
//  bookReader
//
//  Created by Jobs on 2020/6/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookInfoModel.h"
#import "BRAPIClient.h"
#import "DBGHTMLEntityDecoder.h"

@implementation BRBookInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"bookName":@"name",
             @"bookId":@"id",
             @"cover":@"cover",
             @"author":@"author",
             @"categoryId":@"categoryid",
             @"lastupdate":@[@"lastupdate",@"lastupdate_time"],
             @"intro":@"intro",
             @"authorId":@"authorid",
             @"otherBooks":@"list",
             @"categoryName":@"category_name",
             @"desc":@"caption",
             @"isOver":@"isover",
             @"lastChapterId":@"lastChapterId",
             @"lastChapterName":@"lastchaptername",
             @"lastupdateDate":@"lastupdate",
             @"banner":@"banner"
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
    item.siteIndex = [NSNumber numberWithInt:-1]; // 默认-1  表示未选择
    if (!item.authorId) {
        item.authorId = @0;
    }
    if (item.intro) {
        DBGHTMLEntityDecoder *decoder = [[DBGHTMLEntityDecoder alloc] init];
        item.intro = [decoder decodeString:item.intro];
        item.intro = [item.intro stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if ([dic objectForKey:@"list"]) {
        item.otherBooks = [BRBookInfoModel parseDictionaryIntoRecords:[dic objectForKey:@"list"]];
    }
    return item;
}


+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody {
    NSMutableArray *ret = [NSMutableArray array];
    if ([dataBody isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in dataBody) {
            [ret addObject:[BRBookInfoModel parseDictionaryIntoObject:dic]];
        }
    }
    return [NSArray arrayWithArray:ret];
}

#pragma mark- setter


#pragma mark- getter

- (BRSite *)selectSite {
    if (!_selectSite) {
        BRSite *site = [self.sitesArray objectAtIndex:(self.siteIndex.integerValue >= self.sitesArray.count ? self.sitesArray.count -1 : self.siteIndex.integerValue)]; // 这里需要避免 源变更导致的问题
        _selectSite = site;
    }
    return _selectSite;
}


#pragma mark- API

+ (NSURLSessionDataTask *)getbookinfoWithBookId:(NSInteger)bookid
                     isSelect:(BOOL)isSelect
                       sucess:(void(^)(BRBookInfoModel *bookInfo))successBlock
                 failureBlock:(BRObjectFailureBlock)failureBlock {
    return  [[BRAPIClient sharedInstance] getbookinfoWithBookId:bookid isSelect:isSelect sucess:^(id  _Nonnull dataBody) {
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


+ (NSURLSessionDataTask *)getBookListWithCategory:(NSInteger)categoryId
                         isOver:(int)isOver
                           page:(NSInteger)page
                           size:(NSInteger)size
                         sucess:(BRObjectSuccessBlock)successBlock
                   failureBlock:(BRObjectFailureBlock)failureBlock {
    return [[BRAPIClient sharedInstance] getBookListWithCategory:categoryId isOver:isOver page:page size:size sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRBookInfoModel parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (NSURLSessionDataTask *)searchBookWithName:(NSString *)name
                      page:(NSInteger)page
                      size:(NSInteger)size
                    sucess:(BRObjectSuccessBlock)successBlock
              failureBlock:(BRObjectFailureBlock)failureBlock {

    return [[BRAPIClient sharedInstance] searchBookWithName:name page:page size:size sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRBookInfoModel parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (NSURLSessionDataTask *)getRecommendSuccess:(void(^)(NSArray *rotationArray, NSArray *recommendArray, NSArray *hotArray, NSArray *endArray))successBlock
               failureBlock:(BRObjectFailureBlock)failureBlock {
    return [[BRAPIClient sharedInstance] getRecommendSuccess:^(id  _Nonnull dataBody) {
        NSDictionary *dict = (NSDictionary *)dataBody;
        
        NSDictionary *rotationDict = [dict objectForKey:@"3"];
        NSArray *rotation = [BRBookInfoModel parseDictionaryIntoRecords:[rotationDict objectForKey:@"list"]];
        
        NSDictionary *recommendDict = [dict objectForKey:@"7"];
        NSArray *recommend = [BRBookInfoModel parseDictionaryIntoRecords:[recommendDict objectForKey:@"list"]];
        
        NSDictionary *hotDict = [dict objectForKey:@"8"];
        NSArray *hot = [BRBookInfoModel parseDictionaryIntoRecords:[hotDict objectForKey:@"list"]];
        
        NSDictionary *endDict = [dict objectForKey:@"9"];
        NSArray *end = [BRBookInfoModel parseDictionaryIntoRecords:[endDict objectForKey:@"list"]];
        
        
        successBlock(rotation, recommend, hot, end);
        
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (NSURLSessionDataTask *)getRankListWithType:(NSInteger)type
                       page:(NSInteger)page
                       size:(NSInteger)size
                    success:(BRObjectSuccessBlock)successBlock
               failureBlock:(BRObjectFailureBlock)failureBlock {
    return [[BRAPIClient sharedInstance] getRankListWithType:type page:page size:size success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRBookInfoModel parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (NSURLSessionDataTask *)getBookInfosShelfWithBookids:(NSString *)ids
                              sucess:(BRObjectSuccessBlock)successBlock
                        failureBlock:(BRObjectFailureBlock)failureBlock {
    
    return [[BRAPIClient sharedInstance] getBookInfosShelfWithBookids:ids sucess:^(id  _Nonnull dataBody) {
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
