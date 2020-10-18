//
//  CFButtonLeftRight.m
//  bookReader
//
//  Created by Jobs on 2020/9/10.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "CFButtonLeftRight.h"

@implementation CFButtonLeftRight

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /** 修改 title 的 frame */
    // 1.获取 titleLabel 的 frame
    CGRect titleLabelFrame = self.titleLabel.frame;
    // 2.修改 titleLabel 的 frame
    titleLabelFrame.origin.x = 0;
    // 3.重新赋值
    self.titleLabel.frame = titleLabelFrame;
    
    /** 修改 imageView 的 frame */
    // 1.获取 imageView 的 frame
    CGRect imageViewFrame = self.imageView.frame;
    // 2.修改 imageView 的 frame
    imageViewFrame.origin.x = titleLabelFrame.size.width;
    // 3.重新赋值
    self.imageView.frame = imageViewFrame;
}

@end
