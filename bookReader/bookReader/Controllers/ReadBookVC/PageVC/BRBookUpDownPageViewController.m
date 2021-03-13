//
//  BRBookUpDownPageViewController.m
//  bookReader
//
//  Created by chengfei on 2021/2/25.
//  Copyright © 2021 chengfeir. All rights reserved.
//

#import "BRBookUpDownPageViewController.h"
#import "BRBookReadContenViewController.h"
#import "CFReadViewMacros.h"
#import "BRBookReadTextTableViewCell.h"
#import "GVUserDefaults+BRUserDefaults.h"

@interface BRBookUpDownPageViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UILabel* chapterNameLabel;
@property (nonatomic,strong) UILabel* indexLabel;

@end

@implementation BRBookUpDownPageViewController

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CGRect center = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT);
    
    if (CGRectContainsPoint(center, point)){
        if (_block){
            _block();
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    _chapterNameLabel = [[UILabel alloc] init];
    BRChapter *curChapter = [self.viewModel.getAllChapters objectAtIndex:self.viewModel.currentIndex];
    _chapterNameLabel.text = curChapter.name;
    _chapterNameLabel.font = [UIFont systemFontOfSize:12];
    _chapterNameLabel.textColor = BRUserDefault.readInfoColor ? : CFUIColorFromRGBAInHex(0x8F9396, 1);
    [self.view addSubview:_chapterNameLabel];
    [_chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight());
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(kChapterNameLabelHeight);
    }];
    
    
    CGFloat offSetBottom = kReadStatusHeight*(-1);
//    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollsToTop = YES;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_chapterNameLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(offSetBottom);
        make.left.right.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.textColor  = BRUserDefault.readInfoColor?:CFUIColorFromRGBAInHex(0x8F9396, 1);
//    _indexLabel.text = [NSString stringWithFormat:@"第%ld/%ld页",self.index,self.totalNum];
    _indexLabel.font = [UIFont systemFontOfSize:12];
    _indexLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_indexLabel];
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(150);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissGrantureADD:)];
    [tap setNumberOfTapsRequired:1];
    tap.delegate=self;//确认一下代理
    [self.view addGestureRecognizer:tap];
    
    [self.tableView reloadData];
    NSIndexPath* index = [NSIndexPath indexPathForRow:[self.viewModel getCurrentVCIndex] inSection:0];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)disMissGrantureADD:(UITapGestureRecognizer *)gestureRecognizer {
    if (_block){
        _block();
    }
}

- (void)tableViewScroll:(UIScrollView *)scrollView {
/*
     获取处于屏幕中心的cell
     系统方法返回处于tableView某坐标处的cell的indexPath
    */
//scrollView的Y轴偏移量+tableView高度的一半为整个scrollView内容高度的一半
    CGFloat offSetY = scrollView.contentOffset.y + CGRectGetHeight(self.tableView.frame) / 2;
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, offSetY)];
    
    BRChapter *chapter = [self.viewModel.pagedArray objectAtIndex:indexPath.section];
    _chapterNameLabel.text = chapter.name;
    CFDebugLog(@"章节: %ld - page: %ld",indexPath.section, indexPath.row);
    self.viewModel.currentIndex = [[self.viewModel getAllChapters] indexOfObject:chapter];
    [self.viewModel saveBookRecordWithPageIndex:indexPath.row];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 10){
        [self.viewModel loadBeforeChapterTextSucess:^{
            
            NSMutableDictionary *dict = self.viewModel.viewModelGetAllDataDict;
            
            BRChapter *chapter = [self.viewModel.pagedArray objectAtIndex:0];
            NSArray *contentArray = [dict objectForKey:chapter.chapterId];
            
            NSIndexPath* index = [NSIndexPath indexPathForRow:contentArray.count-1 inSection:0];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
        }];
    }
    if (scrollView.contentOffset.y > scrollView.frame.size.height) {
        CGFloat Threshold = 0.9;
        CGFloat currentOffSetY = scrollView.contentOffset.y + scrollView.frame.size.height;

        
        // 总的可滑动区域
        CGFloat totalContentSizeY = scrollView.contentSize.height;
        // 取得当前滑动视图的底边的偏移量
        CGFloat ratio = currentOffSetY/totalContentSizeY;
        // 比较临界值大小
        if (ratio >= Threshold) {
            [self.viewModel loadNextChapterTextSucess:^{
                [self.tableView reloadData];
            }];
        }
    }
}

/**
 手指拖动滑行
 @param decelerate 滑动明确位移返回NO，自动滑行一段位移返回YES
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self tableViewScroll:scrollView];
    }
}

//tableView自动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self tableViewScroll:scrollView];
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark- UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"BRBookReadTextTableViewCell";
    BRBookReadTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[BRBookReadTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
    }
    
    NSMutableDictionary *dict = self.viewModel.viewModelGetAllDataDict;
    
    BRChapter *chapter = [self.viewModel.pagedArray objectAtIndex:indexPath.section];
    
    NSArray *contentArray = [dict objectForKey:chapter.chapterId];
    
    cell.text = [contentArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableDictionary *dict = self.viewModel.viewModelGetAllDataDict;
    
    BRChapter *chapter = [self.viewModel.pagedArray objectAtIndex:section];
    
    NSArray *contentArray = [dict objectForKey:chapter.chapterId];
    
    return contentArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableDictionary *dict = self.viewModel.viewModelGetAllDataDict;
    
    return dict.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT  -kStatusBarHeight() -kChapterNameLabelHeight -kReadStatusHeight -kReadContentOffSetY;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return kChapterNameLabelHeight;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kChapterNameLabelHeight)];
//    bgView.backgroundColor = [UIColor whiteColor];
//
//    BRChapter *chapter = [self.viewModel.pagedArray objectAtIndex:section];
//
//    UILabel *chapterNameLabel = [[UILabel alloc] init];
//    chapterNameLabel.text = chapter.name;
//    chapterNameLabel.font = [UIFont systemFontOfSize:12];
//    chapterNameLabel.textColor = BRUserDefault.readInfoColor ? : CFUIColorFromRGBAInHex(0x8F9396, 1);
//    [bgView addSubview:chapterNameLabel];
//    [chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(kChapterNameLabelHeight);
//    }];
//
//    return bgView;
//}

@end
