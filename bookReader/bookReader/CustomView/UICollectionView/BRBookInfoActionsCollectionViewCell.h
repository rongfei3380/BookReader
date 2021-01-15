//
//  BRBookInfoActionsCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2021/1/14.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRBookInfoModel.h"

#define kBRBookInfoActionsCollectionViewCellHeight 218

@protocol BRBookInfoActionsCollectionViewCellDelegate <NSObject>

- (void)bookInfoActionsCollectionViewCellClickOtherBooksBtn:(UIButton *_Nonnull)button;
- (void)bookInfoActionsCollectionViewCellClickAddShelfButton:(UIButton *_Nonnull)button;
- (void)bookInfoActionsCollectionViewCellClickChapterButton:(UIButton *_Nonnull)button;
- (void)bookInfoActionsCollectionViewCellClickDownloadBtn:(UIButton *_Nonnull)button;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BRBookInfoActionsCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) BRBookInfoModel *bookInfo;
@property(nonatomic, weak) id<BRBookInfoActionsCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
