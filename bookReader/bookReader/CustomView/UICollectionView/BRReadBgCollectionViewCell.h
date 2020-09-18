//
//  BRReadBgCollectionViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/9/17.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 阅读页 背景
@interface BRReadBgCollectionViewCell : UICollectionViewCell {
    UIImageView *_bgImg;
}

@property(nonatomic, strong) UIImage *backImage;


- (void)setBackImage:(UIImage * _Nonnull)backImage isSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
