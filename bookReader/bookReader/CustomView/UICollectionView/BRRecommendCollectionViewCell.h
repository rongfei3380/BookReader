//
//  BRRecommendCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRRecommendCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;

@end

NS_ASSUME_NONNULL_END
