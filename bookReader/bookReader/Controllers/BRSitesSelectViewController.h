//
//  BRSitesSelectViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/30.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseTableViewController.h"
#import "BRSite.h"

NS_ASSUME_NONNULL_BEGIN

/// 选择源
@interface BRSitesSelectViewController : BRBaseTableViewController

@property(nonatomic, strong) NSNumber *bookId;
@property(nonatomic, strong) NSArray<BRSite *>* sitesArray;

@end

NS_ASSUME_NONNULL_END
