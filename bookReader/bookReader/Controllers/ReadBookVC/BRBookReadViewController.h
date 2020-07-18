//
//  BRBookReadViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFBookReadVMDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 阅读界面
@interface BRBookReadViewController : UIViewController<CFBookReadVMDelegate>

/// viewModel
@property(nonatomic, strong)id<CFBookReadVMDelegate> viewModel;
@end

NS_ASSUME_NONNULL_END
