//
//  BRBookReadViewModel.h
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFBookReadVMDelegate.h"
#import "BRBookInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRBookReadViewModel : NSObject<CFBookReadVMDelegate>

- (instancetype)initWithBookModel:(BRBookInfoModel*)model;

@property (nonatomic,strong,readonly) BRBookInfoModel* model;


@end

NS_ASSUME_NONNULL_END
