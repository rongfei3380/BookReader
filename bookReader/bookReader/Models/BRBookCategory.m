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
            NSDictionary *dict = (NSDictionary *)dataBody;
            
            BRBookCategory *male = [BRBookCategory parseDictionaryIntoObject:[[dict objectForKey:@"data"] objectForKey:@"nan"]];
            
            male.categoryName = @"全部";
            
            BRBookCategory *famale = [BRBookCategory parseDictionaryIntoObject:[[dict objectForKey:@"data"] objectForKey:@"nv"]];
            
            NSMutableArray *maleArray = [[BRBookCategory parseDictionaryIntoRecords:[dataBody objectForKey:@"nan"]] mutableCopy];
            [maleArray insertObject:male atIndex:0];
            
            NSMutableArray *famaleArray = [[BRBookCategory parseDictionaryIntoRecords:[dataBody objectForKey:@"nv"]] mutableCopy];
            [famaleArray insertObject:famale atIndex:0];
            
            successBlock(maleArray, famaleArray);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


@end
