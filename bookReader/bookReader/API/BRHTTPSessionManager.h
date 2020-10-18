//
//  BRHTTPSessionManager.h
//  bookReader
//
//  Created by Jobs on 2020/6/4.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRHTTPSessionManager : AFHTTPSessionManager

+(BRHTTPSessionManager *)sharedManager;

@end

NS_ASSUME_NONNULL_END
