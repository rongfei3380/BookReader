//
//  BRBookHistoryCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/10/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

#define kBookHistoryCollectionViewCellHeight 80+20


NS_ASSUME_NONNULL_BEGIN

@interface BRBookHistoryCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;


@end

NS_ASSUME_NONNULL_END
