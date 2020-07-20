//
//  BRBookRecord+database.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookRecord+database.h"

@implementation BRBookRecord (database)

- (instancetype)initWithFMResult:(FMResultSet*)result {
    self = [super init];
    if (self) {
        self.bookId = [NSNumber numberWithInteger:[result stringForColumn:@"book_id"].integerValue];
        self.chapterIndex = [result intForColumn:@"chapter_index"];
        self.recordText = [result stringForColumn:@"record_text"];
        self.chapterName = [result stringForColumn:@"chapter_name"];
        self.recordTime  = [result objectForColumn:@"record_time"];
    }
    return self;
}

@end
