//
//  BRWebviewViewController.h
//  bookReader
//
//  Created by Jobs on 2020/9/12.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 包含有一个 WKWebview 的页面 用来加载本地html
@interface BRWebviewViewController : BRBaseViewController

@property(nonatomic, strong) NSString *loadHtmlName;

@end

NS_ASSUME_NONNULL_END
