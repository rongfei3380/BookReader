//
//  BRBookRecord.h
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRBookRecord : BRBaseModel

@property (nonatomic,copy) NSNumber* bookId;
@property (nonatomic,assign) NSInteger chapterIndex;
@property (nonatomic,copy) NSString* chapterName;
@property (nonatomic,copy) NSString* recordText;
@property (nonatomic,strong) NSDate* recordTime;

- (instancetype)initWithId:(NSNumber*)bookId
                     index:(NSInteger)index
                    record:(NSString*)record
               chapterName:(NSString*)chapterName;


@end

NS_ASSUME_NONNULL_END
