//
//  NSError+BRError.m
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "NSError+BRError.h"

@implementation NSError (BRError)

+ (instancetype)errorWithDescription:(NSString*)description {
    return [self errorWithCode:9999 Description:description];
}

+ (instancetype)errorWithCode:(NSInteger)code Description:(NSString*)description {
    NSError* err = [[NSError alloc]
                    initWithDomain:NSCocoaErrorDomain
                    code:code
                    userInfo:@{
                               NSLocalizedDescriptionKey : description,
                               }];
    return err;
}

@end
