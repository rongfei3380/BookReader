//
//  BRBookCategory.m
//  bookReader
//
//  Created by Jobs on 2020/6/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookCategory.h"
#import "BRAPIClient.h"

@implementation BRBookCategory
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"categoryId":@"id",
             @"categoryName":@"name"
    };
}

+ (id)parseDictionaryIntoObject:(NSDictionary *)dic {
    BRBookCategory *item = [[BRBookCategory alloc] initWithAttributes:dic];
    return item;
}


+ (NSArray *)parseDictionaryIntoRecords:(id)dataBody {
    NSMutableArray *ret = [NSMutableArray array];
    if ([dataBody isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = (NSDictionary *)dataBody;
        
        // 如果有多个用户的话
        if ([[dataDic allKeys] containsObject:@"expressions"]) {
            NSArray *usersDicArray = (NSArray *)[dataDic objectForKey:@"expressions"];
            for (NSDictionary *dic in usersDicArray) {
                [ret addObject:[BRBookCategory parseDictionaryIntoObject:dic]];
            }
        } else {
            [ret addObject:[BRBookCategory parseDictionaryIntoObject:dataDic]];
        }
    } else if ([dataBody isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in dataBody) {
            [ret addObject:[BRBookCategory parseDictionaryIntoObject:dic]];
        }
    }
    return [NSArray arrayWithArray:ret];
}

+ (void)getBookCategorySucess:(void(^)(NSArray *maleCategoryes, NSArray *famaleCategory))successBlock
                 failureBlock:(BRObjectFailureBlock)failureBlock {
    [[BRAPIClient sharedInstance] getBookCategorySucess:^(id  _Nonnull dataBody) {
        if (successBlock) {
            
            
            NSArray *maleArray = [BRBookCategory parseDictionaryIntoRecords:[dataBody objectForKey:@"nan"]];
            NSArray *famaleArray = [BRBookCategory parseDictionaryIntoRecords:[dataBody objectForKey:@"nv"]];
            
            successBlock(maleArray, famaleArray);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


@end
