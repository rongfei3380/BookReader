//
//  CFShadowCornerImageView.h
//  bookReader
//
//  Created by Jobs on 2020/9/11.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYWebImage/YYWebImage.h>

NS_ASSUME_NONNULL_BEGIN

/// 圆角阴影Imageview
@interface CFShadowCornerImageView : UIImageView

- (void)setImageCornerRadius: (CGFloat)radius;

//设置阴影
- (void)setShadowWithColor:(UIColor *)color
             shadowXOffset:(CGFloat)xOffset
             shadowYOffset:(CGFloat)yOffset
              shadowRadius:(CGFloat)radius
             shadowOpacity:(CGFloat)opacity;

@end

NS_ASSUME_NONNULL_END
