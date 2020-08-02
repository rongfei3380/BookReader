//
//  BRMineViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/9.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRMineViewController.h"
#import "BRSettingTableViewCell.h"

@interface BRMineViewController () {
    NSArray *_section0Array;
    NSArray *_section1Array;
}

@end

@implementation BRMineViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    UIImageView *tableHeadView = [[UIImageView alloc] init];
    tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 198);
    tableHeadView.image = [UIImage imageNamed:@"img_bg_profile"];
    
    UIImageView *avaterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_avatar"]];
    [tableHeadView addSubview:avaterImg];
    [avaterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(22);
        make.centerY.mas_offset(kStatusBarHeight()/2.f);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"书友";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    [tableHeadView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(avaterImg.mas_centerY).mas_offset(0);
        make.left.mas_equalTo(avaterImg.mas_right).mas_offset(10);
        make.right.mas_offset(-22);
        make.height.mas_offset(20);
    }];

//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"书友328498745453"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:41/255.0 green:47/255.0 blue:61/255.0 alpha:1.0]}];

//    label.attributedText = string;
    label.alpha = 1.0;
    
    self.tableView.tableHeaderView = tableHeadView;
    self.tableView.contentInset = UIEdgeInsetsMake(kStatusBarHeight()*(-1), 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _section0Array = @[
        @{@"icon":@"profile_list_history", @"title":@"浏览历史"},
        @{@"icon":@"profile_list_share", @"title": @"分享给朋友"}
    ];
    
    _section1Array = @[
        @{@"icon":@"profile_list_helping", @"title":@"意见反馈"},
        @{@"icon":@"profile_list_praise", @"title":@"给我好评"},
        @{@"icon":@"profile_list_aboult", @"title":@"关于软件"},
        @{@"icon":@"profile_list_set", @"title":@"设置"}
    ];
    // Do any additional setup after loading the view.
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark- UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"Identifier";
    BRSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[BRSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
    }
    NSDictionary *dict = nil;
    if (indexPath.section == 0) {
        dict = [_section0Array objectAtIndex:indexPath.row];
    } else if ( indexPath.section == 1) {
        dict = [_section1Array objectAtIndex:indexPath.row];
    }
    
    cell.icon = [dict objectForKey:@"icon"];
    cell.title = [dict objectForKey:@"title"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (section == 0) {
        rows = _section0Array.count;
    } else if ( section == 1) {
        rows = _section1Array.count;
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBRSettingTableViewCellHeight;
}

@end
