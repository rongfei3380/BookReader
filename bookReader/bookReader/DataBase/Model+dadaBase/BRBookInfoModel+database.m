//
//  BRBookInfoModel+database.m
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookInfoModel+database.h"

@implementation BRBookInfoModel (database)

- (instancetype)initWithFMResult:(FMResultSet *)result {
    self = [self init];
    if (self) {
        self.bookName = [result stringForColumn:@"book_name"];
        self.bookId = [NSNumber numberWithInt:[result intForColumn:@"book_id"]];
        self.cover = [result stringForColumn:@"book_cover"];
        self.author = [result stringForColumn:@"author"];
        self.authorId = [NSNumber numberWithInt:[result intForColumn:@"author_id"]];
        self.categoryName = [result stringForColumn:@"category_name"];
        self.categoryId = [NSNumber numberWithInt:[result intForColumn:@"category_id"]];
        self.intro = [result stringForColumn:@"book_intro"];
        self.desc = [result stringForColumn:@"book_desc"];
        self.lastupdateDate = [result dateForColumn:@"lastupdate_time"];
        
        NSString *base64String = [result stringForColumn:@"sites_text"];
        if (base64String) {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            self.sitesArray = [NSArray yy_modelArrayWithClass:[BRSite class] json:decodedString];
        }
        
        self.siteIndex = [NSNumber numberWithInt:[result intForColumn:@"site_index"]];
    }
    return self;
}

@end
