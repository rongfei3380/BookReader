//
//  BRBookListCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/8/16.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kBookListCollectionViewCellHeight 100


@interface BRBookListCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;


@end

NS_ASSUME_NONNULL_END
