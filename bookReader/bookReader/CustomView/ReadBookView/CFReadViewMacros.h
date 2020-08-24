//
//  CFReadViewMacros.h
//  bookReader
//
//  Created by Jobs on 2020/7/21.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#ifndef CFReadViewMacros_h
#define CFReadViewMacros_h

#import "CFCustomMacros.h"

// 1. 章节名称
#define kChapterNameLabelHeight 15

// 2. 阅读区域
#define kReadContentOffSetX 15
#define kReadContentOffSetY 18

// 3. 状态区
#define kReadStatusOffSetX 15
#define kReadStatusHeight  (isIPhoneXSeries() ? (25+69) : 69)
//#define kReadStatusHeight 94

#endif /* CFReadViewMacros_h */
