//
//  BRBaseModel.m
//  bookReader
//
//  Created by Jobs on 2020/6/22.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseModel.h"

@implementation BRBaseModel


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        [self yy_modelSetWithJSON:attributes];
    }    
    return self;
}

#pragma mark - subclass implement this
+ (id)parseDictionaryIntoObject:(NSDictionary *)dic {
    // subclass implement this
    return nil;
}

+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody {
    // subclass implement this
    return nil;
}


#pragma mark --Coding/Copying/hash/equal/description 的YYModel 处理

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init]; return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
