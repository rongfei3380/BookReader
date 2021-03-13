//
//  CFBookReadVMDelegate.h
//  bookReader
//
//  Created by Jobs on 2020/7/16.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"
#import "BRChapterDetail.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^block)(void);
typedef void (^LoadSuccess)(UIViewController* currentVC);
typedef void (^Fail)(NSError* err);

typedef void (^HubSuccess)(NSString* text);
typedef void (^HubFail)(NSString* text);

@protocol CFBookReadVMDelegate <NSObject>


/// 开始初始化 
- (void)startInit;

/// 获取前一个页面
/// @param viewController VC
/// @param doubleSided 是否边缘
- (UIViewController*)viewControllerBeforeViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided;


/// 获取后一个页面
/// @param viewController VC
/// @param doubleSided 是否
- (UIViewController*)viewControllerAfterViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided;


/// 按序号加载章节
/// @param index 序号
- (void)loadChapterWithIndex:(NSInteger)index;


/// 获取书名
- (NSString*)getBookName;

/// 获取所有章节名称
- (NSArray<BRChapter*>*)getAllChapters;

/// 获取新的目录
- (void)getNewAllChapters;

/// 获取当前章节的index
- (NSInteger)getCurrentChapterIndex;

/// 获取VC的index
/// @param vc  需要获取的VC
- (NSInteger)getCurrentVCIndexWithVC:(UIViewController*)vc;

/// 获取当前VC的index
- (NSInteger)getCurrentVCIndex;

/// 刷新所有的页面
- (void)reloadContentViews;

#pragma mark - 用于viewmodel与vc的反向交互

/// 初始化 该方法在ReadVC开始加载某一章节时使用
/// @param block 回调
- (void)startLoadData:(block)block;

///  加载完新的章节
/// @param block
- (void)loadChapters:(block)block;

/**
 * 该方法给VM传入block,用于VM与VC的方向交互
 * @param success 成功
 * @param fail 失败
 */
- (void)loadDataWithSuccess:(LoadSuccess)success Fail:(Fail)fail;

/**
 * 该方法用于VM控制VC显示相对应的hub
 * @param success 成功
 * @param fail 失败
 */
- (void)showHubWithSuccess:(HubSuccess)success Fail:(HubSuccess)fail;


/// 获取 全部的显示page
- (NSArray<UIViewController *> *)viewModelGetAllVCs;

/// 获取分页后的 章节内容
- (NSMutableDictionary *)viewModelGetAllDataDict;

/// 获取书本信息model
- (BRBookInfoModel *)BRBookInfoModel;

/// 删除当前章节缓存
- (void)deleteChapterSave;


/// 删除全书章节缓存
- (void)deleteBookChapterSave;


@end

NS_ASSUME_NONNULL_END
