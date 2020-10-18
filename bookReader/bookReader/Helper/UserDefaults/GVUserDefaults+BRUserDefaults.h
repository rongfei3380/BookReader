//
//  GVUserDefaults+BRUserDefaults.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define BRUserDefault [GVUserDefaults standardUserDefaults]

/// 用来存储一些用户设置
@interface GVUserDefaults (BRUserDefaults)




# pragma mark - 用户阅读配置信息
/* 预加载的章节数量*/
@property (nonatomic,assign) NSInteger adLoadChapters;
/* 用户阅读的富文本设置(字号,间距,颜色等信息)*/
@property (nonatomic,strong) NSDictionary* userReadAttConfig;
@property (nonatomic,strong) NSData* userReadAttConfigData;
/* 阅读器的翻页方向(右<->左 下<->上)*/
@property (nonatomic,assign) enum UIPageViewControllerNavigationDirection PageNaviDirection;
/* 翻页方式(页面卷曲 滚动)*/
@property (nonatomic,assign) enum UIPageViewControllerTransitionStyle PageTransitionStyle;

@property (nonatomic,assign) enum UIPageViewControllerNavigationOrientation PageNaviOrientation;
/* 阅读界面背景颜色*/
@property (nonatomic,strong) UIColor* readBackColor;
//@property (nonatomic,strong) NSData* readBackColorData;
@property (nonatomic,assign) NSInteger readBackColorIndex;  // 背景纹理的位置
/* 阅读界面章节等附属信息颜色*/
@property (nonatomic,strong) UIColor* readInfoColor;
/* 是否是夜间模式*/
@property (nonatomic,assign) BOOL isNightStyle;
/* 阅读界面亮度*/
@property (nonatomic,assign) float readBrightness;


/// 是否为书架模式
@property (nonatomic,assign) BOOL isShelfStyle;

#pragma mark - 借助userDeaults缓存部分轻量信息
/* 搜索热词*/
@property (nonatomic,strong) NSArray* hotWordArr;

/// 是否同意了 用户协议
@property(nonatomic, assign) BOOL isAgreemented;

@end

NS_ASSUME_NONNULL_END
