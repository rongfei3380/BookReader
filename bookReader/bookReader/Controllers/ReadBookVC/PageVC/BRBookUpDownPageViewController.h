//
//  BRBookUpDownPageViewController.h
//  bookReader
//
//  Created by chengfei on 2021/2/25.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBaseTableViewController.h"
#import "BRBookReadViewModel.h"

typedef void (^touchBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BRBookUpDownPageViewController : BRBaseTableViewController

@property(nonatomic, strong) BRBookReadViewModel *viewModel;

@property (nonatomic, strong) touchBlock block;

@end

NS_ASSUME_NONNULL_END
