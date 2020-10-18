//
//  BRCycleCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/7/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRCycleCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;

@end

NS_ASSUME_NONNULL_END
