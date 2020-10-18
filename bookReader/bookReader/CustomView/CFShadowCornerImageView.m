//
//  CFShadowCornerImageView.m
//  bookReader
//
//  Created by Jobs on 2020/9/11.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "CFShadowCornerImageView.h"

@interface CFShadowCornerImageView ()

@property(strong, nonatomic) UIView *shadowContainer;
@property(assign, nonatomic) CGFloat radius;


@end

@implementation CFShadowCornerImageView

//设置圆角
- (void)setImageCornerRadius: (CGFloat)radius {
    self.layer.cornerRadius = radius;
// ios9之后对imageview设置不会触发离屏渲染
    self.layer.masksToBounds = YES;
}

//设置阴影
- (void)setShadowWithColor:(UIColor *)color shadowXOffset:(CGFloat)xOffset
              shadowYOffset:(CGFloat)yOffset
              shadowRadius:(CGFloat)radius
              shadowOpacity:(CGFloat)opacity{

    if (self.superview == nil) {
        NSLog(@"WRNING: a parent view of the image view is necessary to add a shadow view.");
        return;
    }

  //shadowContainer  为在imageview的父view中加的 设置阴影的view
    if (self.shadowContainer != nil) {
        [self.shadowContainer removeFromSuperview];
    }
    self.shadowContainer = [[UIView alloc] initWithFrame: self.frame];
    self.shadowContainer.userInteractionEnabled = NO;
    self.shadowContainer.backgroundColor = [UIColor whiteColor];
    self.shadowContainer.layer.shadowColor = color.CGColor;
    self.shadowContainer.layer.shadowOffset = CGSizeMake(xOffset, yOffset);
    self.shadowContainer.layer.shadowRadius = radius;
    self.shadowContainer.layer.shadowOpacity = opacity;
    self.shadowContainer.layer.cornerRadius = self.layer.cornerRadius;
  //必加该句  直接向Core Animation提供阴影形状，通过调用setShadowPath来提供一个CGPath给视图的Layer，（CGPath为任意你想生成的阴影的形状)，可以防止离屏渲染
    self.radius = radius;
    self.shadowContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;
    self.shadowContainer.clipsToBounds = NO;
    [self.superview insertSubview:self.shadowContainer atIndex:0];
}

- (void)layoutSubviews {
     [super layoutSubviews];
    self.shadowContainer.frame = self.frame;
    self.shadowContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.radius].CGPath;
     self.shadowContainer.layer.cornerRadius = self.layer.cornerRadius;
}


@end
