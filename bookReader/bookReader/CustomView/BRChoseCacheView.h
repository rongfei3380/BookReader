//
//  BRChoseCacheView.h
//  bookReader
//
//  Created by Jobs on 2021/1/21.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BRChoseCacheViewDelegate <NSObject>

- (void)choseCacheViewClickCacheButtonWithChapter:(NSArray *)chapters count:(NSInteger)count;

@end

/// 弹出选择缓存的页面
@interface BRChoseCacheView : UIView

@property(nonatomic, weak) id<BRChoseCacheViewDelegate> delegate;
@property(nonatomic, strong) NSArray *allChapters;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
