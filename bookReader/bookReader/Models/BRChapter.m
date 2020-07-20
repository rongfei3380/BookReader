//
//  BRChapterContent.m
//  bookReader
//
//  Created by Jobs on 2020/7/19.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRChapter.h"
#import "BRAPIClient.h"
#import "BRDataBaseManager.h"

@implementation BRChapter
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"chapterId":@"id",
             @"name":@"name",
             @"siteId":@"siteid",
             @"siteName":@"id",
             @"siteUrl":@"url"
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
+ (void)getChaptersListWithBookId:(NSNumber *)bookId
                           siteId:(NSInteger)siteId
                         sortType:(NSInteger)sortType
                           sucess:(BRObjectSuccessBlock)successBlock
                     failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getChaptersListWithBookId:bookId siteId:siteId sortType:sortType sucess:^(id  _Nonnull dataBody) {
        
        NSArray *list = [BRChapter parseDictionaryIntoRecords:dataBody];
        [[BRDataBaseManager sharedInstance] saveChaptersWithArray:list bookId:bookId];
        if (successBlock) {
            successBlock(list);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}
@end
