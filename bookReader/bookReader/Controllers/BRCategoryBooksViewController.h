//
//  BRCategoryBooksViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseTableViewController.h"
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 分类列表下的书籍列表
@interface BRCategoryBooksViewController : BRBaseTableViewController<ZJScrollPageViewChildVcDelegate>


@property(nonatomic, strong) NSArray *categoryArray;

@end


NS_ASSUME_NONNULL_END
