//
//  BRBookInfoModel+database.h
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookInfoModel.h"
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRBookInfoModel (database)

- (instancetype)initWithFMResult:(FMResultSet*)result;


@end

NS_ASSUME_NONNULL_END
