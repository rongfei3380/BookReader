//
//  UIViewController+Analysis.m
//  bookReader
//
//  Created by chengfei on 2021/4/8.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "UIViewController+Analysis.h"
//#import "MethodSwizzingTool.h"


@implementation UIViewController (Analysis)

//+(void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
////        SEL originalDidLoadSelector = @selector(viewDidLoad);
////        SEL swizzingDidLoadSelector = @selector(user_viewDidLoad);
////        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originalDidLoadSelector swizzingSel:swizzingDidLoadSelector];
//
//    });
//}

//-(void)user_viewDidLoad
//{
//    [self user_viewDidLoad];

   //从配置表中取参数的过程 1 固定参数  2 业务参数（此处参数被target持有）
//    NSString * identifier = [NSString stringWithFormat:@"%@", [self class]];
//    NSDictionary * dic = [[[DataContainer dataInstance].data objectForKey:@"PAGEPV"] objectForKey:identifier];
//    if (dic) {
//        NSString * pageid = dic[@"userDefined"][@"pageid"];
//        NSString * pagename = dic[@"userDefined"][@"pagename"];
//        NSDictionary * pagePara = dic[@"pagePara"];
//
//        __block NSMutableDictionary * uploadDic = [NSMutableDictionary dictionaryWithCapacity:0];
//        [pagePara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//
//            id value = [CaptureTool captureVarforInstance:self withPara:obj];
//            if (value && key) {
//                [uploadDic setObject:value forKey:key];
//            }
//        }];
//
//        NSLog(@"\n 事件唯一标识为：%@ \n  pageid === %@,\n  pagename === %@,\n pagepara === %@ \n", [self class], pageid, pagename, uploadDic);
//    }
//}

@end
