//
//  BRBookRecord.m
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookRecord.h"

@implementation BRBookRecord
- (instancetype)initWithId:(NSNumber*)bookId
                     index:(NSInteger)index
                    record:(NSString*)record
               chapterName:(NSString*)chapterName {
    self = [super init];
    if (self){
        self.bookId = bookId;
        self.chapterIndex = index;
        self.recordText = record;
        self.chapterName = chapterName;
    }
    return self;
}
@end
