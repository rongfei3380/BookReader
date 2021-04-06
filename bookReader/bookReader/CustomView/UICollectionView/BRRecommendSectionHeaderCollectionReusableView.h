//
//  BRRecommendSectionHeaderCollectionReusableView.h
//  bookReader
//
//  Created by chengfei on 2021/4/6.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kBRRecommendSectionHeaderCollectionReusableViewHeight 52

@interface BRRecommendSectionHeaderCollectionReusableView : UICollectionReusableView {
    UILabel *_titleLabel;
}

- (void)setSectionHeader:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
