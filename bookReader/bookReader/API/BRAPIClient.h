//
//  BRAPIClient.h
//  bookReader
//
//  Created by Jobs on 2020/6/4.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <CFBaseAPIClient.h>
NS_ASSUME_NONNULL_BEGIN

@interface BRAPIClient : CFBaseAPIClient


/// 获取榜单列表
/// @param type 榜单类型,默认为1:人气榜,2:热搜榜,3:完结榜,4:新书榜,5:好评榜
/// @param page 页码,默认0
/// @param size 每页数量,默认10
/// @param successBlock 返回的数据
/// @param failureBlock 返回的错误码
- (void)getRankListWithType:(NSInteger)type
                       page:(NSInteger)page
                       size:(NSInteger)size
                     success:(CFAPIClientSuccessBlock)successBlock
                failureBlock:(CFAPIClientFailureBlock)failureBlock;


/// 获取书籍详情
/// @param bookid 小说id
/// @param isSelect 是否为搜索点击,0:否,1:是 默认为0
/// @param successBlock 书籍详情
/// @param failureBlock error
- (void)getbookinfoWithBookId:(NSInteger)bookid
                     isSelect:(BOOL)isSelect
                       sucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock;


/// 获取书籍分类
/// @param successBlock
/// @param failureBlock
- (void)getBookCategorySucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock;



/// 获取分类下的书籍列表
/// @param categoryId 分类id
/// @param page 页码,默认为0
/// @param size 每页显示数量,默认为10
/// @param successBlock
/// @param failureBlock 
- (void)getBookListWithCategory:(NSInteger)categoryId
                           page:(NSInteger)page
                           size:(NSInteger)size
                         sucess:(CFAPIClientSuccessBlock)successBlock
                   failureBlock:(CFAPIClientFailureBlock)failureBlock;


/// 搜索书籍
/// @param name 搜索关键字 书名
/// @param page 页码,默认0
/// @param size 每页数量,默认10
/// @param successBlock 搜索得到的书籍列表
/// @param failureBlock error
- (void)searchBookWithName:(NSString *)name
                      page:(NSInteger)page
                      size:(NSInteger)size
                    sucess:(CFAPIClientSuccessBlock)successBlock
              failureBlock:(CFAPIClientFailureBlock)failureBlock;



/// 小说章节列表
/// @param bookId 书籍id
/// @param siteId 源id
/// @param sortType  章节排序,asc:升序,   desc:降序  1 升序 0 降序
/// @param successBlock 小说章节列表
/// @param failureBlock  error
- (void)getChaptersListWithBookId:(NSNumber *)bookId
                           siteId:(NSInteger)siteId
                         sortType:(NSInteger)sortType
                           sucess:(CFAPIClientSuccessBlock)successBlock
                     failureBlock:(CFAPIClientFailureBlock)failureBlock;



/// 获取小说章节内容
/// @param bookId 小说id
/// @param chapterId 章节id
/// @param siteId 源id
/// @param successBlock  章节内容
/// @param failureBlock error
- (void)getChapterContentWithBookId:(NSNumber *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(CFAPIClientSuccessBlock)successBlock
                       failureBlock:(CFAPIClientFailureBlock)failureBlock;



///  获取书的 源列表
/// @param bookId  书籍id
/// @param successBlock 源列表
/// @param failureBlock error
- (void)getSiteListWithBookId:(NSNumber *)bookId
                       sucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock;


/// 获取排行榜推荐和轮播
/// @param successBlock  成功内容
/// @param failureBlock 失败内容
- (void)getRecommendSuccess:(CFAPIClientSuccessBlock)successBlock
               failureBlock:(CFAPIClientFailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
