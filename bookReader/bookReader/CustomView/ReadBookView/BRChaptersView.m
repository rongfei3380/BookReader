//
//  BRChaptersView.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRChaptersView.h"
#import "CFCustomMacros.h"
#import <Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "BRChapter.h"
#import "BRMessageHUD.h"
#import "CFDataUtils.h"

@interface BRChaptersView ()<UITableViewDelegate, UITableViewDataSource>

/// 背景
@property (nonatomic,strong) UIView* muluView;
/// 书名
@property (nonatomic,strong) UILabel *bookNameLabel;
/// 更新时间
@property (nonatomic,strong) UILabel *updateTimeLabel;
/// 目录列表
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *button;
/* 是否倒序*/
@property (nonatomic,assign) BOOL isDescending;

@property (nonatomic,strong) NSArray* dataArray;


@end


@implementation BRChaptersView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    CGRect setView = CGRectMake(0, 0,  SCREEN_WIDTH, self.frame.size.height*(1/4.f));
    
    if (CGRectContainsPoint(setView,point)){
        self.isShowMulu = NO;
    }
}

#pragma mark- super

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self initialSubViews];
    }
    return self;
}


#pragma mark- private

- (void)initialSubViews {
    self.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0.5);
    
    self.muluView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*(1/4.f), self.frame.size.width, self.frame.size.height*(3/4.f))];
    self.muluView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    self.muluView.layer.cornerRadius = 12;
    [self addSubview:self.muluView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
    headView.backgroundColor = CFUIColorFromRGBAInHex(0xF9F9F9, 1);
    headView.layer.cornerRadius = 12;
    [self.muluView addSubview:headView];
    
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, self.frame.size.width - 40, 20)];
    self.bookNameLabel.font = [UIFont systemFontOfSize:16];
    self.bookNameLabel.text = self.bookName;
    self.bookNameLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
    [headView addSubview:self.bookNameLabel];
    
    self.updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bookNameLabel.frame)+2, self.frame.size.width -40, 16)];
    self.updateTimeLabel.font = [UIFont systemFontOfSize:12];
    self.updateTimeLabel.textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
    [headView addSubview:self.updateTimeLabel];
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 17, 30, 30)];
    [self.button addTarget:self action:@selector(changeScending) forControlEvents:UIControlEventTouchUpInside];
    [self.button setImage:[UIImage imageNamed:@"mulu_descending"] forState:UIControlStateNormal];
//    self.button.touchAreaInsets = UIEdgeInsetsMake(5, 5, 5, 10);
    [headView addSubview:self.button];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.muluView.frame.size.width, self.muluView.frame.size.height - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, (isIPhoneXSeries() ? 34:0), 0);
    [self.muluView addSubview:self.tableView];
}

- (void)setIsShowMulu:(BOOL)isShowMulu {
    _isShowMulu = isShowMulu;
    if (isShowMulu){
        [self setNeedsLayout];
        
        [self.tableView reloadData];
        [self scrollToCurrentIndex];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self setNeedsLayout];
            self.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0.5);
        }];
    }else{
        [self setNeedsLayout];
        [UIView animateWithDuration:0.2 animations:^{
            [self setNeedsLayout];
        }];
        if (self.didSelectHidden){
            self.didSelectHidden();
        }
    }
}

- (void)scrollToCurrentIndex {
    if (!_isDescending){
        if (_chapters.count<=self.currentIndex){
            return;
        }
        
        NSIndexPath* index = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        if (_chapters.count<self.dataArray.count - self.currentIndex - 1){
            return;
        }
        
//        NSIndexPath* index = [NSIndexPath indexPathForRow:self.dataArray.count - self.currentIndex - 1 inSection:0];
        NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)setBookName:(NSString *)bookName {
    _bookName = bookName;
    
    self.bookNameLabel.text = _bookName;
}

- (void)setBookInfo:(BRBookInfoModel *)bookInfo {
    _bookInfo = bookInfo;
    self.updateTimeLabel.text = [NSString stringWithFormat:@"更新于 %@", [CFDataUtils createBookUpdateTime:self.bookInfo.lastupdateDate]];
}

- (void)setChapters:(NSArray<BRChapter *> *)chapters {
    _chapters = chapters;
    
    if (_chapters.count == 0) {
        [BRMessageHUD showErrorStatus:@"暂无章节信息" to:self];
        [_tableView reloadData];
        return;
    }
    
    if (_isDescending){
        self.dataArray = [NSArray arrayWithArray:[[_chapters reverseObjectEnumerator] allObjects]];
    }else{
        self.dataArray = [NSArray arrayWithArray:_chapters];
    }
    
    [_tableView reloadData];
}

- (void)changeScending {
    if (self.chapters.count == 0) {
        [BRMessageHUD showErrorStatus:@"暂无章节信息" to:self];
        return;
    }
    
    if (self.isDescending){
        [self.button setImage:[UIImage imageNamed:@"mulu_descending"] forState:UIControlStateNormal];
        self.dataArray = [NSArray arrayWithArray:self.chapters];
    }else{
        [self.button setImage:[UIImage imageNamed:@"mulu_ascending"] forState:UIControlStateNormal];
        NSArray *arr = [[self.chapters reverseObjectEnumerator] allObjects];
        self.dataArray = [NSArray arrayWithArray:arr];
    }
    
    self.isDescending = !self.isDescending;
    
    [_tableView reloadData];
    [self scrollToCurrentIndex];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleCell"];
    }
    
    NSInteger row = self.isDescending?(self.dataArray.count-indexPath.row):(indexPath.row + 1);
    
    
    BRChapter *chapter = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", chapter.name];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    if (row - 1 == self.currentIndex){
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = self.isDescending?(self.dataArray.count-indexPath.row):(indexPath.row + 1);
    if (self.didSelectChapter){
        self.didSelectChapter(row-1);
    }
    self.isShowMulu = NO;
}

@end
