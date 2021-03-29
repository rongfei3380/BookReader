//
//  BRBookReadViewModel.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFBookReadVMDelegate.h"
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRBookReadViewModel : NSObject<CFBookReadVMDelegate>

- (instancetype)initWithBookModel:(BRBookInfoModel*)model;

@property (nonatomic,strong,readonly) BRBookInfoModel* bookModel;
@property (nonatomic, strong) NSArray<BRSite *> *sitesArray;
/// 当前是那个章节
@property(nonatomic, assign) NSInteger currentIndex;
/// 分页过的章节id 数组
@property(nonatomic, strong) NSMutableArray *pagedArray;

- (void)loadBeforeChapterTextSucess:(nullable void (^)(void))sucess;
- (void)loadNextChapterTextSucess:(nullable void (^)(void))sucess;
- (void)saveBookRecordWithPageIndex:(NSInteger)pageIndex;

@end

NS_ASSUME_NONNULL_END
