//
//  BRBookReadContenViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 阅读界面中的一页
@interface BRBookReadContenViewController : BRBaseViewController<UIGestureRecognizerDelegate>

/* 该"页"需要显示的文本内容*/
@property (nonatomic,copy) NSString* text;
/* 章节名称*/
@property (nonatomic,copy) NSString* chapterName;
/* 总页数*/
@property (nonatomic,assign) NSInteger totalNum;
/* 当前页数*/
@property (nonatomic,assign) NSInteger index;

/// 初始化方法
/// @param text 章节内容
/// @param chapterName 章节名称
/// @param totalNum 页码
/// @param index 位置
- (instancetype)initWithText:(NSString*)text chapterName:(NSString*)chapterName totalNum:(NSInteger)totalNum index:(NSInteger)index;

@property (nonatomic,strong,readonly) UIViewController* backVC;

@end

NS_ASSUME_NONNULL_END
