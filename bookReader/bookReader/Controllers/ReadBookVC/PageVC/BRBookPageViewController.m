//
//  BRBookPageViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookPageViewController.h"
#import "CFCustomMacros.h"

@interface BRBookPageViewController ()

@end

@implementation BRBookPageViewController

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CGRect center = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT);
    
    if (CGRectContainsPoint(center, point)){
        if (_block){
            _block();
        }
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}

@end
