//
//  BRBookReadViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBaseViewController.h"
#import "CFBookReadVMDelegate.h"
#import "BRBookReadViewModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 阅读界面
@interface BRBookReadViewController : BRBaseViewController<CFBookReadVMDelegate>

/// viewModel
@property(nonatomic, strong)id<CFBookReadVMDelegate> viewModel;
@property(nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
