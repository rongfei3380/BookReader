//
//  CFAltUtils.m
//  bookReader
//
//  Created by chengfei on 2021/2/8.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "CFAltUtils.h"

@implementation CFAltUtils

+ (NSDictionary *)configDictionary {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

+ (NSString *)UMConfigureKey {
    NSDictionary *dict = [CFAltUtils configDictionary];
    NSString *UMConfigureKey = [dict objectForKey:@"UMConfigureKey"];
    return UMConfigureKey;
}

+ (NSString *)QQGroupUin {
    NSDictionary *dict = [CFAltUtils configDictionary];
    NSString *QQGroup = [dict objectForKey:@"QQGroupUin"];
    return QQGroup;
}

+ (NSString *)QQGroupKey {
    NSDictionary *dict = [CFAltUtils configDictionary];
    NSString *QQGroup = [dict objectForKey:@"QQGroupKey"];
    return QQGroup;
}

+ (NSString *)AppStoreId {
    NSDictionary *dict = [CFAltUtils configDictionary];
    NSString *AppStoreId = [dict objectForKey:@"AppStoreId"];
    return AppStoreId;
}

+ (NSString *)BuglyAppId {
    NSDictionary *dict = [CFAltUtils configDictionary];
    NSString *BuglyAppId = [dict objectForKey:@"BuglyAppId"];
    return BuglyAppId;
}

@end
