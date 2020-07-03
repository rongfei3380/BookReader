//
//  BRChapter.m
//  bookReader
//
//  Created by Jobs on 2020/6/26.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRChapter.h"
#import "BRAPIClient.h"

@implementation BRChapter

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"bookId":@"novelid",
             @"chapterId":@"id",
             @"chapterName":@"name",
             @"siteId":@"siteid",
             @"siteName":@"id",
             @"siteUrl":@"url",
             @"content":@"content",
             @"preChapterName":@"preinfo.name",
             @"preChapterId":@"preinfo.id",
             @"nextChapterName":@"nextinfo.name",
             @"nextChapterId":@"nextinfo.id"
    };
}

+ (id)parseDictionaryIntoObject:(NSDictionary *)dic {
    BRChapter *item = [[BRChapter alloc] initWithAttributes:dic];
    return item;
}


+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody {
    NSMutableArray *ret = [NSMutableArray array];
    
    if ([dataBody isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in dataBody) {
            [ret addObject:[BRChapter parseDictionaryIntoObject:dic]];
        }
    }
    return [NSArray arrayWithArray:ret];
}

#pragma mark- API

+ (void)getChaptersListWithBookId:(NSString *)bookId
                           siteId:(NSInteger)siteId
                         sortType:(NSInteger)sortType
                           sucess:(BRObjectSuccessBlock)successBlock
                     failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getChaptersListWithBookId:bookId siteId:siteId sortType:sortType sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRChapter parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)getChapterContentWithBookId:(NSString *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(void(^)(BRChapter *chapter))successBlock
                       failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getChapterContentWithBookId:bookId chapterId:chapterId siteId:siteId sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRChapter parseDictionaryIntoObject:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
