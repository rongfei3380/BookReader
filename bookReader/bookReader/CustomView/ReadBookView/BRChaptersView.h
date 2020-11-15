//
//  BRChaptersView.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRChapter.h"
#import "BRBookInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^select)(NSInteger index);
typedef void (^selectHidden)(void);



/// 目录界面
@interface BRChaptersView : UIView

@property (nonatomic,copy) NSString* bookName;
@property (nonatomic, strong) BRBookInfoModel *bookInfo;
@property (nonatomic,strong) NSArray<BRChapter*>* chapters;
@property (nonatomic,assign) BOOL isShowMulu;
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) select didSelectChapter;
@property (nonatomic,strong) selectHidden didSelectHidden;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
