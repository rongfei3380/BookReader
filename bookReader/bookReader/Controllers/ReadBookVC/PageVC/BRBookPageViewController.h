//
//  BRBookPageViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^touchBlock)(void);

@interface BRBookPageViewController : UIPageViewController

@property (nonatomic, strong) touchBlock block;


@end

NS_ASSUME_NONNULL_END
