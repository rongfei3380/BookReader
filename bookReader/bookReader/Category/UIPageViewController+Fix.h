//
//  UIPageViewController+Fix.h
//  bookReader
//
//  Created by Jobs on 2020/11/23.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// for fix Crash NSInvalidArgumentException
///  The number of view controllers provided (0) doesn't match the number required (2) for the requested transition

@interface UIPageViewController (Fix)

@end

NS_ASSUME_NONNULL_END
