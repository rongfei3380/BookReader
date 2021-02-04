//
//  BRBookListTableViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kBookListTableViewCellHeight 122


/// 分类页面的书籍cell
@interface BRBookListTableViewCell : UITableViewCell


@property(nonatomic, strong) BRBookInfoModel *bookInfo;

@end

NS_ASSUME_NONNULL_END
