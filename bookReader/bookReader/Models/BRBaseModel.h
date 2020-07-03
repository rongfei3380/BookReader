//
//  BRBaseModel.h
//  bookReader
//
//  Created by Jobs on 2020/6/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BRDataBodyObjectSuccessBlock) (id dataBody);
typedef void (^BRObjectSuccessBlock) (NSArray *recodes);
typedef void (^BRObjectFailureBlock) (NSError *error);


@interface BRBaseModel : NSObject

/**
 数据解析
 */
- (id)initWithAttributes:(NSDictionary *)attributes;

#pragma mark - subclass implement this

+ (id)parseDictionaryIntoObject:(NSDictionary *)dic;

+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody;

@end

NS_ASSUME_NONNULL_END
