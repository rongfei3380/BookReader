//
//  BRBookCategory.h
//  bookReader
//
//  Created by Jobs on 2020/6/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 书籍分类
@interface BRBookCategory : BRBaseModel

/// f分类id
@property(nonatomic, strong) NSNumber *categoryId;
/// 分类名称
@property(nonatomic, strong) NSString *categoryName;



+ (void)getBookCategorySucess:(void(^)(NSArray *maleCategoryes, NSArray *famaleCategory))successBlock
                 failureBlock:(BRObjectFailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
