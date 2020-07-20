//
//  BRBookInfoModel.h
//  bookReader
//
//  Created by Jobs on 2020/6/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRBaseModel.h"
#import "BRSite.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRBookInfoModel : BRBaseModel

/*小说名称*/
@property(nonatomic, copy) NSString *bookName;
/*小说id*/
@property(nonatomic, strong) NSNumber *bookId;
/*小说封面图*/
@property(nonatomic, strong) NSString *cover;
/*小说作者*/
@property(nonatomic, strong) NSString *author;
/*作者id*/
@property(nonatomic, strong) NSNumber *authorId;
/*分类id*/
@property(nonatomic, strong) NSNumber *categoryId;
/*分类名称*/
@property(nonatomic, strong) NSString *categoryName;
/*简短描述*/
@property(nonatomic, strong) NSString *desc;
/*小说简介*/
@property(nonatomic, strong) NSString *intro;
/*最后更新时间戳*/
@property(nonatomic, strong) NSNumber *lastupdate;
@property(nonatomic, strong) NSDate *lastupdateDate;
/*作者其他小说*/
@property(nonatomic, strong) NSArray *otherBooks;

/// 书籍相关的源
@property(nonatomic, strong) NSArray* sitesArray;

/// 获取书籍详情
/// @param bookid 小说id
/// @param isSelect 是否为搜索点击,0:否,1:是 默认为0
/// @param successBlock 书籍信息
/// @param failureBlock error
+ (void)getbookinfoWithBookId:(NSInteger)bookid
                     isSelect:(BOOL)isSelect
                       sucess:(void(^)(BRBookInfoModel *bookInfo))successBlock
                 failureBlock:(BRObjectFailureBlock)failureBlock;



/// 获取分类下的书籍列表
/// @param categoryId 分类id
/// @param page 页码,默认为0
/// @param size 每页显示数量,默认为10
/// @param successBlock
/// @param failureBlock
+ (void)getBookListWithCategory:(NSInteger)categoryId
                           page:(NSInteger)page
                           size:(NSInteger)size
                         sucess:(BRObjectSuccessBlock)successBlock
                   failureBlock:(BRObjectFailureBlock)failureBlock;

/// 搜索书籍
/// @param name 搜索关键字 书名
/// @param page 页码,默认0
/// @param size 每页数量,默认10
/// @param successBlock 搜索得到的书籍列表
/// @param failureBlock error
+ (void)searchBookWithName:(NSString *)name
                      page:(NSInteger)page
                      size:(NSInteger)size
                    sucess:(BRObjectSuccessBlock)successBlock
              failureBlock:(BRObjectFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END

