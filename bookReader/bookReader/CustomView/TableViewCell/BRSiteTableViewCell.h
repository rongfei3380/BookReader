//
//  BRSiteTableViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/7/30.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRSite.h"

#define kBRSiteTableViewCellHeight 58

NS_ASSUME_NONNULL_BEGIN

/// 选择源页面的cell
@interface BRSiteTableViewCell : UITableViewCell

@property(nonatomic, strong) BRSite *site;

@end

NS_ASSUME_NONNULL_END
