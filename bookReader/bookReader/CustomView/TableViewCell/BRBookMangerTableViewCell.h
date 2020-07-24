//
//  BRBookMangerTableViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/7/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

#define kBookMangerTableViewCellHeight 100

NS_ASSUME_NONNULL_BEGIN

@interface BRBookMangerTableViewCell : UITableViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;

@end

NS_ASSUME_NONNULL_END
