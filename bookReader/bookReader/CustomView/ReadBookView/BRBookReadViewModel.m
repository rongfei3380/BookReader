//
//  BRBookReadViewModel.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookReadViewModel.h"
#import "BRDataBaseManager.h"
#import "BRChapter.h"
#import "BRBookReadContenViewController.h"
#import "GVUserDefaults+BRUserDefaults.h"

@interface BRBookReadViewModel ()

/// 修改model 为读写
@property (nonatomic,strong,readwrite) BRBookInfoModel* model;
///  数据库管理
@property(nonatomic, strong) BRDataBaseManager *dataBase;
/// 当前章节
@property(nonatomic, strong) BRChapter *currentChapter;
/// 当前是那个章节
@property(nonatomic, assign) NSInteger currentIndex;
/// 当前页数
@property(nonatomic, assign) NSInteger currentVCIndex;
/// 当前页面
@property(nonatomic, strong) BRBookReadContenViewController *currentVC;
/// 章节数组
@property(nonatomic, strong) NSArray *chaptersArray;
/// 章节对用的页面数组
@property(nonatomic, strong) NSArray *vcArray;

#pragma mark- Block

@property(nonatomic, strong) LoadSuccess loadSuccess;
@property(nonatomic, strong) Fail loadFail;
@property(nonatomic, strong) block startLoadBlock;
@property(nonatomic, strong) HubSuccess hubSuccess;
@property(nonatomic, strong) HubFail hubFail;


@end

@implementation BRBookReadViewModel

- (instancetype)initWithBookModel:(BRBookInfoModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        self.dataBase = [BRDataBaseManager sharedInstance];
    }
    return self;
}

#pragma mark- data

/**
* 初始化时应该完成的事情有:
* 查询数据库中是否有当前书缓存的章节信息,没有则去查询,有则先使用缓存,并后台更新缓存
* 等待上一步完成,去查找有没有阅读的记录,有则加载记录章节,没有则加载第一章
* 等待上一步完成,去更新页面信息。
*/
- (void)initiaData {
    
}

/// 查找阅读记录
- (void)initialRecord {
    
}

/**
 * 保存书本的阅读记录
 */
- (void)saveBookRecordWithPageIndex:(NSInteger)pageIndex {
    
}

/// 获取章节内容成功之后,应该进行区分
/// @param isNext 是否next
/// @param recordText 阅读历史内容
- (void)pagingContentVCsWithisNext:(BOOL)isNext recordText:(NSString*)recordText {
    
}
/**
 * 预加载
 */
- (void)advanceLoadChapters
{
    NSInteger index = self.currentIndex;
    NSMutableArray* chapters = [NSMutableArray array];
    NSInteger adLoadChapters = (BRUserDefault.adLoadChapters>=1?:3)<=20?:20;
    for (NSInteger i = 0; i < adLoadChapters; i++) {
        ++index;
        if (index < self.chaptersArray.count){
            [chapters addObject:self.chaptersArray[index]];
        }
    }
    
    if (chapters.count >= 1){
//        [self.bookApi advanceLoadChapters:chapters];
    }
}

/// 加载指定章节的内容
/// @param model 章节
/// @param isNext 加载的是否为下一章
/// @param recordText 阅读记录值
- (void)loadChapterTextWith:(BRChapter*)model isNext:(BOOL)isNext recordText:(NSString*)recordText {
    
}

/// 记载上一章节 加载完成后默认在前一章节的最后一页
- (void)loadBeforeChapterText {
    NSLog(@"加载上一章节");
    NSInteger index = self.currentIndex;
    if (index - 1>=0 && index - 1<self.chaptersArray.count){
        BRChapter* model = self.chaptersArray[index - 1];
        [self loadChapterTextWith:model isNext:NO recordText:nil];
    }else{
        NSLog(@"chaptersArray.count=%ld,index=%ld",self.chaptersArray.count,index);
        if (self.hubFail){
            self.hubFail(@"已经是第一章了");
        }
    }
}


///  加载下一章节,加载完成后默认显示后一章节的第一页
- (void)loadNextChapterText {
    NSLog(@"加载下一章节");
    NSInteger index = self.currentIndex;
    
    if (index + 1>=0 && index + 1<self.chaptersArray.count){
        BRChapter* model = self.chaptersArray[index + 1];
        [self loadChapterTextWith:model isNext:YES recordText:nil];
    }else{
        NSLog(@"chaptersArray.count=%ld,index=%ld",self.chaptersArray.count,index);
        if (self.hubFail){
            self.hubFail(@"已经是最后一章了");
        }
    }
}

#pragma mark - BookReadVMDelegate
- (NSInteger)getCurrentChapterIndex {
    return self.currentIndex;
}

- (NSInteger)getCurrentVCIndexWithVC:(UIViewController*)vc {
    NSInteger index = [self.vcArray indexOfObject:vc];
    
    return index;
}

- (NSInteger)getCurrentVCIndex{
    return self.currentVCIndex;
}

- (void)reloadContentViews {
    [self initialRecord];
}

- (NSArray<NSString*>*)getAllChapters {
    NSMutableArray* array = [NSMutableArray array];
    for (BRChapter* model in self.chaptersArray) {
        [array addObject:model.chapterName];
    }
    
    return array;
}

- (void)loadChapterWithIndex:(NSInteger)index {
    if (index < self.chaptersArray.count){
        BRChapter* model = self.chaptersArray[index];
        [self loadChapterTextWith:model isNext:YES recordText:nil];
    }else{
        [self loadChapterTextWith:self.chaptersArray.lastObject isNext:YES recordText:nil];
    }
}

- (NSString*)getBookName {
    return self.model.bookName;
}

- (void)startInit {
    /* 开始加载数据*/
    [self initiaData];
}

- (void)loadDataWithSuccess:(LoadSuccess)success Fail:(Fail)fail {
    self.loadFail = fail;
    self.loadSuccess = success;
}

- (void)showHubWithSuccess:(HubSuccess)success Fail:(HubSuccess)fail {
    self.hubFail = fail;
    self.hubSuccess = success;
}

- (void)startLoadData:(block)block
{
    self.startLoadBlock = block;
}

/* 获取前一个界面*/
- (UIViewController*)viewControllerBeforeViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided {
    /* UIPageViewController在UIPageViewControllerTransitionStyleScroll模式下,会连续向前/向后请求两次
       目前的方法只能是通过标记暂时解决一下这个问题,
     */
    static NSInteger scrollTimes;
    
    NSInteger index;
    if (doubleSided){
        index = [self.vcArray indexOfObject:self.currentVC];
        scrollTimes = 0;
    }else
        index = [self.vcArray indexOfObject:viewController];
    
    /* 返回背面*/
    if (doubleSided && [viewController isKindOfClass:[BRBookReadContenViewController class]]){
        self.currentVC = (BRBookReadContenViewController*)viewController;
        return self.currentVC.backVC;
    }
    
    if (index - 1 >=0 && index - 1 < self.vcArray.count){
        /* 记录阅读历史*/
        self.currentVCIndex = index - 1;
        [self saveBookRecordWithPageIndex:index - 1];
        self.currentVC = self.vcArray[index - 1];

        return self.currentVC;
    }
    if (!doubleSided && index==0){
        if (scrollTimes > 0)
            [self loadBeforeChapterText];
        else{
            BRBookReadContenViewController* lv = self.vcArray.firstObject;
            BRBookReadContenViewController* newV = [[BRBookReadContenViewController alloc] initWithText:lv.text chapterName:lv.chapterName totalNum:lv.totalNum index:lv.index];
            return newV;
            
        }
        
        scrollTimes = 1;
        return nil;
    }
    /* 网络加载*/
    [self loadBeforeChapterText];
    return nil;
}

/* 获取后一界面*/
- (UIViewController*)viewControllerAfterViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided {
    static NSInteger scrollTimes;
    
    NSInteger index;
    if (doubleSided){
        index = [self.vcArray indexOfObject:self.currentVC];
        scrollTimes = 0;
    }
    else
        index = [self.vcArray indexOfObject:viewController];
    
    /* 返回背面*/
    if (doubleSided && [viewController isKindOfClass:[BRBookReadContenViewController class]]){
        self.currentVC = (BRBookReadContenViewController*)viewController;
        return self.currentVC.backVC;
    }
    
    if (index + 1>=0 && index + 1<self.vcArray.count){
        /* 记录阅读历史*/
        self.currentVCIndex = index + 1;
        [self saveBookRecordWithPageIndex:index + 1];
        self.currentVC = self.vcArray[index + 1];
        
        return self.currentVC;
    }
    
    if (!doubleSided && index==self.vcArray.count - 1){
        if (scrollTimes > 0)
            [self loadBeforeChapterText];
        else{
            BRBookReadContenViewController* lv = self.vcArray.lastObject;
            BRBookReadContenViewController* newV = [[BRBookReadContenViewController alloc] initWithText:lv.text chapterName:lv.chapterName totalNum:lv.totalNum index:lv.index];
            return newV;
            
        }
        
        scrollTimes = 1;
        return nil;
    }
    /* 网络加载*/
    [self loadNextChapterText];
    return nil;
}

- (NSArray<UIViewController *> *)viewModelGetAllVCs {
    return self.vcArray;
}

- (BRBookInfoModel*)getBookInfoModel {
    return self.model;
}

/* 删除当前章节的缓存*/
- (void)deleteChapterSave {
//    if ([self.dataBase deleteChapterTextWithUrl:self.currentChapterTextModel.url]){
//        [self loadBeforeChapterText];
//    }
}

/* 删除全书章节缓存*/
- (void)deleteBookChapterSave {
//    if ([self.dataBase deleteChapterTextWithBookId:self.model.related_id]){
//        [self loadBeforeChapterText];
//    }
}

@end
