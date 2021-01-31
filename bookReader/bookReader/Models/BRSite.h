//
//  BRSite.h
//  bookReader
//
//  Created by Jobs on 2020/6/29.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 用来处理书本的 源
@interface BRSite : BRBaseModel

/// 源 id
@property(nonatomic, strong) NSNumber *siteId;
/// 小说id
@property(nonatomic, strong) NSNumber *bookId;
/// 源 名称
@property(nonatomic, strong) NSString *siteName;
/// 小说最后一章的名称
@property(nonatomic, strong) NSString *lastChapterName;
/// 是否被选中
@property(nonatomic, strong) NSNumber *isSelected;
///  源标记 越大越新
@property(nonatomic, strong) NSNumber *oid;

/*最后更新时间戳*/
@property(nonatomic, strong) NSNumber *lastupdate;
@property(nonatomic, strong) NSDate *lastupdateDate;


#pragma mark API

///  获取书的 源列表
/// @param bookId  书籍id
/// @param successBlock 源列表
/// @param failureBlock error
+ (NSURLSessionDataTask *)getSiteListWithBookId:(NSNumber *)bookId
                       sucess:(BRObjectSuccessBlock)successBlock
                 failureBlock:(BRObjectFailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
