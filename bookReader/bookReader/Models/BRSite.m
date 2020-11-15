//
//  BRSite.m
//  bookReader
//
//  Created by Jobs on 2020/6/29.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRSite.h"
#import "BRAPIClient.h"

@implementation BRSite


+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"siteId":@"siteid",
             @"bookId":@"novelid",
             @"siteName":@"sitename",
             @"lastChapterName":@"name",
             @"oid":@"oid",
             @"lastupdate":@"time"
    };
}

+ (id)parseDictionaryIntoObject:(NSDictionary *)dic {
    BRSite *item = [[BRSite alloc] initWithAttributes:dic];
    item.lastupdateDate = [NSDate dateWithTimeIntervalSince1970:item.lastupdate.integerValue];
    return item;
}


+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody {
    NSMutableArray *ret = [NSMutableArray array];
    
    if ([dataBody isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in dataBody) {
            [ret addObject:[BRSite parseDictionaryIntoObject:dic]];
        }
    }
    return [NSArray arrayWithArray:ret];
}

#pragma mark- API

+ (void)getSiteListWithBookId:(NSNumber *)bookId
                       sucess:(BRObjectSuccessBlock)successBlock
                 failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getSiteListWithBookId:bookId sucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock([BRSite parseDictionaryIntoRecords:dataBody]);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
