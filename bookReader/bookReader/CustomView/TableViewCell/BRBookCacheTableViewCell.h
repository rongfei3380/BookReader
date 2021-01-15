//
//  BRBookCacheTableViewCell.h
//  bookReader
//
//  Created by Jobs on 2021/1/11.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCacheTask.h"

NS_ASSUME_NONNULL_BEGIN

#define kBRBookCacheTableViewCellHeight 110

@protocol BRBookCacheTableViewCellDelegate <NSObject>

- (void)bookCacheTableViewCellClickControlButton:(UIButton *)button cacheTask:(BRCacheTask *)cacheTask;

- (void)bookCacheTableViewCellClickDeleteButton:(UIButton *)button cacheTask:(BRCacheTask *)cacheTask;

@end


@interface BRBookCacheTableViewCell : UITableViewCell

@property(nonatomic, strong)BRCacheTask *cacheTask;
@property(nonatomic, weak)id<BRBookCacheTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
