//
//  BRChaptersTableViewCell.h
//  bookReader
//
//  Created by chengfei on 2021/1/29.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRChapter.h"
#import "BRBookInfoModel.h"

#define kBRChaptersTableViewCellHeight 40

NS_ASSUME_NONNULL_BEGIN

@interface BRChaptersTableViewCell : UITableViewCell {
    UILabel *_chapterNameLabel;
    UILabel *_cacheStateLabel;
}


@property(nonatomic, assign) BOOL isCurrentIndex;

- (void)setChapter:(BRChapter * _Nonnull)chapter bookInfo:(BRBookInfoModel *)book;

@end

NS_ASSUME_NONNULL_END
