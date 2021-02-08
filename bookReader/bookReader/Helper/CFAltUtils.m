//
//  CFAltUtils.m
//  bookReader
//
//  Created by chengfei on 2021/2/8.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "CFAltUtils.h"

@implementation CFAltUtils

+ (NSString *)UMConfigureKey {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *UMConfigureKey = [dict objectForKey:@"UMConfigureKey"];
    return UMConfigureKey;
}

+ (NSString *)QQGroupUin {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *QQGroup = [dict objectForKey:@"QQGroupUin"];
    return QQGroup;
}

+ (NSString *)QQGroupKey {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *QQGroup = [dict objectForKey:@"QQGroupKey"];
    return QQGroup;
}

+ (NSString *)AppStoreId {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *AppStoreId = [dict objectForKey:@"AppStoreId"];
    return AppStoreId;
}

@end
