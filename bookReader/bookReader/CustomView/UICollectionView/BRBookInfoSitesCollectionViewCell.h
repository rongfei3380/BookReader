//
//  BRBookInfoSitesCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

#define kBRBookInfoSitesCollectionViewCellHeight 99

NS_ASSUME_NONNULL_BEGIN

@interface BRBookInfoSitesCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;

@end

NS_ASSUME_NONNULL_END
