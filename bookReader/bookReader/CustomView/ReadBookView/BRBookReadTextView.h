//
//  BRBookReadTextView.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 用于文本渲染的view
@interface BRBookReadTextView : UIView

/// 用于渲染的文本
@property(nonatomic, strong)NSString *text;

/// 使用文本初始化
/// @param text 渲染的文本
- (instancetype)initWithText:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
