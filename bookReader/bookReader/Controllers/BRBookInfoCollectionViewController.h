//
//  BRBookInfoCollectionViewController.h
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBaseCollectionViewController.h"
#import "CFBookReadVMDelegate.h"
@class BRBookInfoModel;


NS_ASSUME_NONNULL_BEGIN

@interface BRBookInfoCollectionViewController : BRBaseCollectionViewController

@property(nonatomic, strong) BRBookInfoModel *bookInfo;
@property (nonatomic,strong) id<CFBookReadVMDelegate> viewModel;

@end

NS_ASSUME_NONNULL_END
