//
//  BRRecommendCollectionReusableView.h
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

@protocol BRRecommendCollectionReusableViewDelegate <NSObject>

- (void)recommendCollectionReusableViewActionButtonsClick:(NSInteger )index title:(NSString *_Nullable)title;

- (void)cycleScrollViewDidSelectItemAtIndex:(NSInteger )index;

@end

#define kRecommendCollectionReusableViewHeight (114/335.f)*(SCREEN_WIDTH -20*2)+ (20 +55 +25+20)


NS_ASSUME_NONNULL_BEGIN

/// 排行页面的 滚动推荐位
@interface BRRecommendCollectionReusableView : UICollectionReusableView

@property(nonatomic, strong) NSArray<BRBookInfoModel *> *booksArray;

@property(nonatomic, weak)id<BRRecommendCollectionReusableViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
