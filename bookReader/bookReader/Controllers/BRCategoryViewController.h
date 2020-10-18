//
//  BRCategoryViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"
#import "ZJScrollPageView.h"

NS_ASSUME_NONNULL_BEGIN

/// 分类页面的父页面
@interface BRCategoryViewController : BRBaseViewController<ZJScrollPageViewDelegate> {
    NSMutableArray *_buttonTitlesMutableArray;  // head button 标题
    UIButton *_selectedButton;
}

@property(strong, nonatomic)NSArray<UIViewController<ZJScrollPageViewChildVcDelegate> *> *childVcs;
@property (weak, nonatomic) ZJContentView *contentView;
@property (assign, nonatomic) NSInteger selectedIndex;


@end

NS_ASSUME_NONNULL_END
