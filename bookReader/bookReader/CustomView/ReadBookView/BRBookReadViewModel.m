//
//  BRBookReadViewModel.m
//  bookReader
//
//  Created by Jobs on 2020/7/18.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBookReadViewModel.h"
#import "BRDataBaseManager.h"
#import "BRChapterDetail.h"
#import "BRBookReadContenViewController.h"
#import "GVUserDefaults+BRUserDefaults.h"
#import "CFCustomMacros.h"
#import "CFReadViewMacros.h"
#import "NSError+BRError.h"

#import "BRBookInfoModel.h"
#import "BRChapterDetail.h"
#import "BRChapter.h"
#import "NSString+size.h"

@interface BRBookReadViewModel ()

/// 修改model 为读写
@property (nonatomic,strong,readwrite) BRBookInfoModel* bookModel;
///  数据库管理
@property(nonatomic, strong) BRDataBaseManager *dataBase;
/// 当前章节
@property(nonatomic, strong) BRChapter *currentChapter;
@property(nonatomic, strong) BRChapterDetail *currentChapterDetail;

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
        self.bookModel = model;
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
    BRBookInfoModel *dbModel = [self.dataBase selectBookInfoWithBookId:self.bookModel.bookId];
    if (dbModel){
        self.bookModel = dbModel;
    }
    if (!self.sitesArray) {
        self.sitesArray = dbModel.sitesArray;
    }
    
    /* 去数据库查找是否有本地缓存的章节信息*/
    BRSite *site = self.sitesArray.firstObject;
    NSArray* arr = [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:self.bookModel.bookId siteId:site.siteId];
    if (arr.count >= 1){
        
//        /* 已有章节缓存,去查找阅读记录*/
        self.chaptersArray = [NSArray arrayWithArray:arr];
        [self initialRecord];
        [self loadChaptersWithRecord:NO];
    }else{
        
        /* 没有章节缓存,去加载章节内容*/
        [self loadChaptersWithRecord:YES];
    }
    
}


/**
 * 加载章节列表
 */
- (void)loadChaptersWithRecord:(BOOL)isRecord{
    if (isRecord){
        if (self.startLoadBlock){
            self.startLoadBlock();
        }
    }
    
    BRSite *site = [_sitesArray firstObject];
    kWeakSelf(self)
    [BRChapter getChaptersListWithBookId:self.bookModel.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        self.chaptersArray = [recodes mutableCopy];
        /* 去查找阅读记录*/
        if (isRecord){
            [self initialRecord];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        kStrongSelf(self)
        if (self.loadFail){
            self.loadFail(error);
        }
    }];
}

/// 查找阅读记录
- (void)initialRecord {
    @try {
        BRBookRecord* model = [[BRDataBaseManager sharedInstance] selectBookRecordWithBookId:_bookModel.bookId];
//        /* 有阅读记录*/
        if (model){
            CFDebugLog(@"阅读记录:第:%ld章",model.chapterIndex);
            if (model.chapterIndex >= self.chaptersArray.count){
                [self loadChapterTextWith:self.chaptersArray.lastObject isNext:YES recordText:nil];
            }else{
                [self loadChapterTextWith:self.chaptersArray[model.chapterIndex] isNext:YES recordText:model.recordText];
            }
        }else{
            CFDebugLog(@"没有找到阅读记录");
            /* 没有阅读记录*/
            [self loadChapterTextWith:self.chaptersArray[self.currentIndex] isNext:YES recordText:nil];
        }
    } @catch (NSException *exception) {
        CFDebugLog(@"查找书本阅读记录失败");
        if (self.loadFail){
            self.loadFail(nil);
        }
    }
}

/**
 * 保存书本的阅读记录
 */
- (void)saveBookRecordWithPageIndex:(NSInteger)pageIndex {
    kWeakSelf(self);
    kDISPATCH_ON_GLOBAL_QUEUE_LOW(^(){
        kStrongSelf(self);
        @try {
            NSInteger chapterIndex = self.currentIndex;
            NSString* text = ((BRBookReadContenViewController*)self.vcArray[pageIndex]).text;
            NSString* name = ((BRBookReadContenViewController*)self.vcArray[pageIndex]).chapterName;
            NSString* record;
            
            if (text.length >= 20){
                record = [text substringToIndex:20];
            }else{
                record = text;
            }
            
            if (chapterIndex >= 0){
                BRBookRecord *model = [[BRBookRecord alloc] initWithId:self->_bookModel.bookId index:chapterIndex record:record chapterName:name];
                [[BRDataBaseManager sharedInstance] saveRecordWithChapterModel:model];
            }
            
        } @catch (NSException *exception) {
            CFDebugLog(@"书本阅读记录保存失败");
        }
    });
}

/// 获取章节内容成功之后,应该进行区分
/// @param isNext 是否next
/// @param recordText 阅读历史内容
- (void)pagingContentVCsWithisNext:(BOOL)isNext recordText:(NSString*)recordText {
    NSArray* textArr = [NSString pagingWith:self.currentChapterDetail.content Size:CGSizeMake(SCREEN_WIDTH -15*2, SCREEN_HEIGHT  -kStatusBarHeight() -kChapterNameLabelHeight -kReadStatusHeight -kReadContentOffSetY)];
    NSMutableArray* vcs = [NSMutableArray array];
    
    NSInteger index = 0;
    for (NSInteger len = 0; len < textArr.count; len++)
    {
        NSString* text = textArr[len];
        /* 查找记录值所在的页*/
        if (recordText){
            if ([text containsString:recordText]){
                index = len;
            }
        }
        /* 初始化显示界面*/
        
        BRBookReadContenViewController* vc = [[BRBookReadContenViewController alloc] initWithText:text chapterName:self.currentChapter.name totalNum:textArr.count index:len+1];
        if(vc){
            [vcs addObject:vc];
        }
    }
    
    self.vcArray = [NSArray arrayWithArray:vcs];
    
    BRBookReadContenViewController* currenVC;
    
    /* 通知pageView刷新界面*/
    if (!kStringIsEmpty(recordText)){
        currenVC = self.vcArray[index];
        self.currentVCIndex = index;
    }else{
        if (isNext){
            self.currentVCIndex = 0;
            currenVC = self.vcArray.firstObject;
        }else{
            self.currentVCIndex = self.vcArray.count - 1;
            currenVC = self.vcArray.lastObject;
        }
    }
    
    /* 记录阅读历史*/
    @try {
        [self saveBookRecordWithPageIndex:[self.vcArray indexOfObject:currenVC]];
    } @catch (NSException *exception) {
        CFDebugLog(@"保存阅读历史错误");
    }
    
    self.currentVC = currenVC;
    
    if (self.loadSuccess){
        self.loadSuccess(currenVC);
    }
}
/**
 * 预加载
 */
- (void)advanceLoadChapters {
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
        for (BRChapterDetail *item in chapters) {
            [BRChapterDetail getChapterContentWithBookId:_bookModel.bookId chapterId:item.chapterId.integerValue siteId:_bookModel.currentSite.siteId.integerValue sucess:^(BRChapterDetail * _Nonnull chapterDetail) {
                
            } failureBlock:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}

/// 加载指定章节的内容
/// @param model 章节
/// @param isNext 加载的是否为下一章
/// @param recordText 阅读记录值
- (void)loadChapterTextWith:(BRChapter*)model isNext:(BOOL)isNext recordText:(NSString*)recordText {
    if (self.startLoadBlock){
           self.startLoadBlock();
       }
       
       if (!model){
           if (self.loadFail){
               self.loadFail([NSError errorWithDescription:@"暂无章节信息"]);
           }
           return;
       }
    BRSite *site = [self.sitesArray firstObject];
    kWeakSelf(self)
    [BRChapterDetail getChapterContentWithBookId:_bookModel.bookId chapterId:model.chapterId.integerValue siteId:site.siteId.longValue sucess:^(BRChapterDetail * _Nonnull chapterDetail) {
        kStrongSelf(self)
        /* 改变记录值*/
        self.currentChapter = model;
        self.currentChapterDetail = chapterDetail;
        self.currentIndex = [self.chaptersArray indexOfObject:self.currentChapter];
          if (self.currentIndex >= self.chaptersArray.count)
              self.currentIndex = 0;
          
          /* 分页*/
          @try {
              [self pagingContentVCsWithisNext:isNext recordText:recordText];
          } @catch (NSException *exception) {
              CFDebugLog(@"书本分页失败");
              if (self.loadFail){
                  self.loadFail([NSError errorWithDescription:@"书本分页失败"]);
              }
          }
      
      /* 预加载*/
      [self advanceLoadChapters];
    } failureBlock:^(NSError * _Nonnull error) {
        if (self.loadFail){
            self.loadFail(error);
        }
    }];
}

/// 记载上一章节 加载完成后默认在前一章节的最后一页
- (void)loadBeforeChapterText {
    NSLog(@"加载上一章节");
    NSInteger index = self.currentIndex;
    if (index - 1>=0 && index - 1<self.chaptersArray.count){
        BRChapterDetail* model = self.chaptersArray[index - 1];
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
    CFDebugLog(@"加载下一章节");
    NSInteger index = self.currentIndex;
    
    if (index + 1>=0 && index + 1<self.chaptersArray.count){
        BRChapterDetail* model = self.chaptersArray[index + 1];
        [self loadChapterTextWith:model isNext:YES recordText:nil];
    }else{
        CFDebugLog(@"chaptersArray.count=%ld,index=%ld",self.chaptersArray.count,index);
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

- (NSArray<BRChapter*>*)getAllChapters {
    return _chaptersArray;
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
    return self.bookModel.bookName;
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
    return self.bookModel;
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
