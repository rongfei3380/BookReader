//
//  BRChapter+database.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRChapter+database.h"

@implementation BRChapter (database)

- (instancetype)initWithFMResult:(FMResultSet *)result {
    self = [self init];
    if (self) {
        self.bookId = [NSNumber numberWithInt:[result intForColumn:@"book_id"]];
        self.name = [result stringForColumn:@"chapter_name"];
        self.chapterId = [NSNumber numberWithInt:[result intForColumn:@"chapter_id"]];
        self.siteName = [result stringForColumn:@"site_name"];
        self.siteId = [NSNumber numberWithInt:[result intForColumn:@"site_id"]];
        self.time = [NSNumber numberWithInt:[result intForColumn:@"time"]];
    }
    return self;
}
@end
