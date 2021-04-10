//
//  BRHistoryBooksViewController.h
//  bookReader
//
//  Created by Jobs on 2020/9/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseTableViewController.h"
#import "BRBaseCollectionViewController.h"
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 浏览历史
@interface BRHistoryBooksViewController : BRBaseCollectionViewController<ZJScrollPageViewChildVcDelegate>

@end

NS_ASSUME_NONNULL_END
