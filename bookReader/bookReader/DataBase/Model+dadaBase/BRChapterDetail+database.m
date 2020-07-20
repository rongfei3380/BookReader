//
//  BRChapterDetail+database.m
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRChapterDetail+database.h"

@implementation BRChapterDetail (database)

- (instancetype)initWithFMResult:(FMResultSet*)result {
    self = [super init];
    if (self) {
        self.bookId = [NSNumber numberWithInteger:[result stringForColumn:@"book_id"].integerValue];
        self.chapterId = [NSNumber numberWithInteger:[result stringForColumn:@"chapter_id"].integerValue];
        self.chapterName = [result stringForColumn:@"chapter_name"];
        self.siteId = [NSNumber numberWithInteger:[result stringForColumn:@"site_id"].integerValue];
        self.siteName = [result stringForColumn:@"chapter_index"];
        self.content = [result stringForColumn:@"content"];
       
        self.preChapterId = [NSNumber numberWithInteger:[result stringForColumn:@"pre_chapter_id"].integerValue];
        self.nextChapterId = [NSNumber numberWithInteger:[result stringForColumn:@"next_chapter_id"].integerValue];
        
        self.time  = [result objectForColumn:@"time"];
    }
    return self;
}

@end
