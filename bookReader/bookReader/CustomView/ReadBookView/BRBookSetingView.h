//
//  BRBookSetingView.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^reloadView)(void);

/// 阅读器设置页面
@interface BRBookSetingView : UIView

@property (nonatomic,strong) reloadView block;
@property (nonatomic,strong) reloadView sliderValueBlock;

@end

NS_ASSUME_NONNULL_END
