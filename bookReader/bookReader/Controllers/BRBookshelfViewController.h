//
//  BRBookshelfViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseCollectionViewController.h"
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 书架 页面
@interface BRBookshelfViewController : BRBaseCollectionViewController<ZJScrollPageViewChildVcDelegate>

@property(nonatomic, assign) BOOL isShelf; // 是否为书架模式
- (void)gotoBooksManager;

@end

NS_ASSUME_NONNULL_END
