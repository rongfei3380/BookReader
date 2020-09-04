//
//  BRChapter.m
//  bookReader
//
//  Created by Jobs on 2020/6/26.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRChapterDetail.h"
#import "BRAPIClient.h"
#import "BRDataBaseManager.h"
#import "DBGHTMLEntityDecoder.h"

@implementation BRChapterDetail

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
             @"nextChapterId":@"nextinfo.id",
    };
}

+ (id)parseDictionaryIntoObject:(NSDictionary *)dic {
    BRChapterDetail *item = [[BRChapterDetail alloc] initWithAttributes:dic];
    item.content = [item.content stringByReplacingOccurrencesOfString:@"　　<br/><br/>" withString:@""];
    item.content = [item.content stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"<br/>"];
    item.content = [item.content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
//    item.content = [item.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    item.content = [item.content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if (item.content) {
        DBGHTMLEntityDecoder *decoder = [[DBGHTMLEntityDecoder alloc] init];
        item.content = [decoder decodeString:item.content];
    }
    return item;
}


+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody {
    NSMutableArray *ret = [NSMutableArray array];
    
    if ([dataBody isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in dataBody) {
            [ret addObject:[BRChapterDetail parseDictionaryIntoObject:dic]];
        }
    }
    return [NSArray arrayWithArray:ret];
}

#pragma mark- API

+ (void)getChapterContentWithBookId:(NSNumber *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(void(^)(BRChapterDetail *chapterDetail))successBlock
                       failureBlock:(BRObjectFailureBlock)failureBlock {
    BRChapterDetail *dbDetai = [[BRDataBaseManager sharedInstance] selectChapterContentWithChapterId:[NSNumber numberWithInteger:chapterId]];
    if (dbDetai) {
        if (successBlock) {
            successBlock(dbDetai);
        }
    } else {
        [[BRAPIClient sharedInstance] getChapterContentWithBookId:bookId chapterId:chapterId siteId:siteId sucess:^(id  _Nonnull dataBody) {
            if (successBlock) {
                
                BRChapterDetail *chapterDetail = [BRChapterDetail parseDictionaryIntoObject:dataBody];
                [[BRDataBaseManager sharedInstance] saveChapterContentWithModel:chapterDetail];
                
                successBlock(chapterDetail);
            }
        } failureBlock:^(NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

@end
