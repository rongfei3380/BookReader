//
//  BRBookInfoDescCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

#define kBRBookInfoDescCollectionViewCellHeight 90+40

@protocol BRBookInfoDescCollectionViewCellDelegate <NSObject>

- (void)bookInfoDescCollectionViewCellClickDetailButton:(CGFloat )height;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BRBookInfoDescCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;
@property(nonatomic, weak)id<BRBookInfoDescCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
