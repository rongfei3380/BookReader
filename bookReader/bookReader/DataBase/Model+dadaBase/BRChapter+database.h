//
//  BRChapter+database.h
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRChapter.h"
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRChapter (database)
- (instancetype)initWithFMResult:(FMResultSet*)result;
@end

NS_ASSUME_NONNULL_END
