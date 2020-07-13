//
//  BRBookInfoViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/10.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"
@class BRBookInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface BRBookInfoViewController : BRBaseViewController

@property(nonatomic, strong) BRBookInfoModel *bookInfo;

@end

NS_ASSUME_NONNULL_END
