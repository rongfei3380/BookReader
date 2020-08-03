//
//  BRSettingTableViewCell.h
//  bookReader
//
//  Created by Jobs on 2020/8/3.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBRSettingTableViewCellHeight 55;

NS_ASSUME_NONNULL_BEGIN

@interface BRSettingTableViewCell : UITableViewCell

@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
