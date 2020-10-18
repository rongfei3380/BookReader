//
//  BRHTTPSessionManager.m
//  bookReader
//
//  Created by Jobs on 2020/6/4.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRHTTPSessionManager.h"

@implementation BRHTTPSessionManager

+ (instancetype)manager {
     
    BRHTTPSessionManager* manager = [super manager];
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    

    return manager;
}

static BRHTTPSessionManager *manager;
+(BRHTTPSessionManager *)sharedManager {
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           manager = [BRHTTPSessionManager manager];
       });
       return manager;
   }

@end
