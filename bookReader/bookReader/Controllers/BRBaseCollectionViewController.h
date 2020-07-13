//
//  BRCollectionViewController.h
//  bookReader
//
//  Created by Jobs on 2020/7/8.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, CollectionBaseEnableModule){
    CollectionBaseEnableModuleNone = 0,
    CollectionBaseEnableModulePullRefresh = 1 << 0,
    CollectionBaseEnableModuleLoadmore = 1 << 1,
    CollectionBaseEnableModuleLoadmoreOverFlag = 1 << 2,
};

extern NSString* const kCollectionViewCellIdentifier;
extern NSString* const kCollectionReuseViewIdentifier;

@interface BRBaseCollectionViewController : BRBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


/**
 允许的模块
 默认为None
 */
@property (nonatomic, assign) CollectionBaseEnableModule enableCollectionBaseModules;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

#pragma mark - public


@end

NS_ASSUME_NONNULL_END
