//
//  NSError+BRError.h
//  bookReader
//
//  Created by Jobs on 2020/7/20.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (BRError)

+ (instancetype)errorWithCode:(NSInteger)code Description:(NSString*)description;
+ (instancetype)errorWithDescription:(NSString*)description;

@end

NS_ASSUME_NONNULL_END
