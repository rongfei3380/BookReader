//
//  BRChaptersView.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRChapter.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^select)(NSInteger index);


/// 目录界面
@interface BRChaptersView : UIView

@property (nonatomic,copy) NSString* bookName;

@property (nonatomic,strong) NSArray<NSString*>* chapters;
@property (nonatomic,assign) BOOL isShowMulu;
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) select didSelectChapter;


@end

NS_ASSUME_NONNULL_END
