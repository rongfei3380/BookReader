//
//  BRDataBaseManager.h
//  bookReader
//
//  Created by Jobs on 2020/6/29.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 有关书籍的 数据库管理
@interface BRDataBaseManager : NSObject

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
