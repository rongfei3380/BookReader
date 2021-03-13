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
#import "BRReadViewReusePool.h"

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
/// 是否章节跳跃
@property(nonatomic, assign) BOOL isChangeChapter;
/// 当前页面
@property(nonatomic, strong) BRBookReadContenViewController *currentVC;
/// 章节数组
@property(nonatomic, strong) NSArray <BRChapter*>*chaptersArray;
/// 章节对用的页面数组
//@property(nonatomic, strong) NSArray *vcArray;

///  分页后的章节内容  章节index :  <NSArray *> content
@property(nonatomic, strong) NSMutableDictionary *dataDict;

@property(nonatomic, strong) BRReadViewReusePool *readViewReusePool;

#pragma mark- Block

@property(nonatomic, strong) LoadSuccess loadSuccess;
@property(nonatomic, strong) Fail loadFail;
@property(nonatomic, strong) block startLoadBlock;
@property(nonatomic, strong) block loadChaptersSuccess;
@property(nonatomic, strong) HubSuccess hubSuccess;
@property(nonatomic, strong) HubFail hubFail;


@end

@implementation BRBookReadViewModel

- (instancetype)initWithBookModel:(BRBookInfoModel *)model {
    self = [super init];
    if (self) {
        self.bookModel = model;
        self.dataBase = [BRDataBaseManager sharedInstance];
        self.readViewReusePool = [[BRReadViewReusePool alloc] init];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark- data

- (void) getSitesWithBook:(BRBookInfoModel *)model {
    kWeakSelf(self)
    [BRSite getSiteListWithBookId:model.bookId sucess:^(NSArray * _Nonnull recodes) {
        kStrongSelf(self)
        self.sitesArray = [recodes mutableCopy];
        
        BRSite *site = [self getTheLastSite];
        NSInteger siteIndex = [self->_sitesArray indexOfObject:site];
        model.siteIndex = [NSNumber numberWithInteger:siteIndex];
        
        
        [[BRDataBaseManager sharedInstance] updateBookSourceWithBookId:model.bookId sites:self.sitesArray curSiteIndex:siteIndex];
        [self initiaData];
    } failureBlock:^(NSError * _Nonnull error) {
        if (self.loadFail){
            self.loadFail(error);
        }
    }];
}

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
    
    self.dataDict = [NSMutableDictionary dictionary];
    
    if (!self.sitesArray) {
        [self getSitesWithBook:dbModel];
    } else {
     /* 去数据库查找是否有本地缓存的章节信息*/
        BRSite *site = [self.sitesArray objectAtIndex:(self.bookModel.siteIndex.integerValue >= self.sitesArray.count ? self.sitesArray.count -1 : self.bookModel.siteIndex.integerValue)]; // 这里需要避免 源变更导致的问题
        NSArray* arr = [[BRDataBaseManager sharedInstance] selectChaptersWithBookId:self.bookModel.bookId siteId:site.siteId];
        if (arr.count >= 1){
            
    //        /* 已有章节缓存,去查找阅读记录*/
            self.chaptersArray = [NSArray arrayWithArray:arr];
            [self initialRecord];
//            [self loadChaptersWithRecord:YES];
        }else{
            
            /* 没有章节缓存,去加载章节内容*/
            [self loadChaptersWithRecord:NO];
        }
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
    } else {
        BRSite *site = nil;
        if (self.bookModel.siteIndex.intValue >= 0) {
            site = [_sitesArray objectAtIndex:(self.bookModel.siteIndex.integerValue >= _sitesArray.count ? _sitesArray.count-1 : self.bookModel.siteIndex.integerValue)];
        } else {
            site = [self getTheLastSite];
            NSInteger siteIndex = [_sitesArray indexOfObject:site];
            self.bookModel.siteIndex = [NSNumber numberWithInteger:siteIndex];
        }
        
        kWeakSelf(self)
        [BRChapter getChaptersListWithBookId:self.bookModel.bookId siteId:site.siteId.integerValue sortType:1 sucess:^(NSArray * _Nonnull recodes) {
            kStrongSelf(self)
            self.chaptersArray = [recodes mutableCopy];
            if (self.loadChaptersSuccess){
                self.loadChaptersSuccess();
            }            /* 去查找阅读记录*/
            [self initialRecord];
        } failureBlock:^(NSError * _Nonnull error) {
            kStrongSelf(self)
            if (self.loadFail){
                self.loadFail(error);
            }
        }];
    }
}

/// 查找阅读记录
- (void)initialRecord {
    @try {
        BRBookRecord* model = [[BRDataBaseManager sharedInstance] selectBookRecordWithBookId:_bookModel.bookId.stringValue];
//        /* 有阅读记录*/
        if (model){
            CFDebugLog(@"阅读记录:第:%ld章",model.chapterIndex +1);
            /* 改变记录值*/
            self.currentIndex = model.chapterIndex;
            if (model.chapterIndex >= self.chaptersArray.count){
                [self loadChapterTextWith:self.chaptersArray.lastObject isNext:YES recordText:nil sucess:^{
                    
                }];
            }else{
                [self loadChapterTextWith:self.chaptersArray[model.chapterIndex] isNext:YES recordText:model.recordText sucess:^{
                    
                }];
            }
        }else{
            CFDebugLog(@"没有找到阅读记录");
            /* 没有阅读记录*/
            [self loadChapterTextWith:self.chaptersArray[self.currentIndex] isNext:YES recordText:nil sucess:^{
                
            }];
        }
    } @catch (NSException *exception) {
        CFDebugLog(@"查找书本阅读记录失败");
        NSError *error = [NSError errorWithDescription:@"查找书本阅读记录失败"];
        if (self.loadFail){
            self.loadFail(error);
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
            
            NSArray *textArray = [self->_dataDict objectForKey:self.currentChapter.chapterId];
            
            NSInteger chapterIndex = self.currentIndex;
            NSString* text = textArray[pageIndex];
            NSString* name = self.currentChapter.name;
            NSString* record;
            
            if (text.length >= 20){
                record = [text substringToIndex:20];
            }else{
                record = text;
            }
//            CFDebugLog(@"==========");
//            CFDebugLog(@"书本阅读记录  第%ld章 %@", chapterIndex, name);
//            CFDebugLog(@"==========");
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
- (void)pagingContentVCsWithisNext:(BOOL)isNext
                        recordText:(NSString*)recordText
                            sucess:(nullable void (^)(void))sucess{
    
    NSString *content = [NSString stringWithFormat:@"%@\n%@", self.currentChapter.name, self.currentChapterDetail.content];
    
    NSArray* textArr = [NSString pagingWith:content Size:CGSizeMake(SCREEN_WIDTH -15*2, SCREEN_HEIGHT  -kStatusBarHeight() -kChapterNameLabelHeight -kReadStatusHeight -kReadContentOffSetY)];
    
//    NSMutableArray* vcs = [NSMutableArray array];
    NSInteger index = 0;
    for (NSInteger len = 0; len < textArr.count; len++) {
        NSString* text = textArr[len];
        /* 查找记录值所在的页*/
        if (recordText){
            if ([text containsString:recordText]){
                index = len;
            }
        }
//        /* 初始化显示界面*/
        BRBookReadContenViewController* vc = (BRBookReadContenViewController* )[self.readViewReusePool dequeueReusebleView];
        if (!vc) {
            vc = [[BRBookReadContenViewController alloc] initWithText:text chapterName:self.currentChapter.name totalNum:textArr.count index:len +1];
            [self.readViewReusePool addUsingView:vc];
        }
        vc.text = text;
        vc.chapterName = self.currentChapter.name;
        vc.totalNum = textArr.count;
        vc.index = len +1;
//        BRBookReadContenViewController* vc = [[BRBookReadContenViewController alloc] initWithText:text chapterName:self.currentChapter.name totalNum:textArr.count index:len +1];
//        if(vc){
//            [vcs addObject:vc];
//        }
    }
    
//    self.vcArray = [NSArray arrayWithArray:vcs];
    
    BRBookReadContenViewController* currenVC = (BRBookReadContenViewController* )[self.readViewReusePool dequeueReusebleView];
   
    
    /* 通知pageView刷新界面*/
    if (!kStringIsEmpty(recordText)){
        self.currentVCIndex = index;
    }else{
        if (isNext){
            self.currentVCIndex = 0;
//            currenVC = self.vcArray.firstObject;
        }else{
            self.currentVCIndex = textArr.count - 1;
//            currenVC = self.vcArray.lastObject;
        }
    }
    
    if (!currenVC) {
        currenVC = [[BRBookReadContenViewController alloc] initWithText:textArr[self.currentVCIndex] chapterName:self.currentChapter.name totalNum:textArr.count index:self.currentVCIndex +1];
        [self.readViewReusePool addUsingView:currenVC];
    }
    [_dataDict setObject:textArr forKey:self.currentChapterDetail.chapterId];
    
    if (!self.pagedArray) {
        self.pagedArray = [NSMutableArray array];
    }
    
    if (isNext) {
        if (![self.pagedArray containsObject:self.currentChapter]) {
            [self.pagedArray addObject:self.currentChapter];
        }
    } else {
        if (![self.pagedArray containsObject:self.currentChapter]) {
            [self.pagedArray insertObject:self.currentChapter atIndex:0];
        }
    }
    
    /* 记录阅读历史*/
    @try {
        [self saveBookRecordWithPageIndex:self.currentVCIndex];
    } @catch (NSException *exception) {
        CFDebugLog(@"保存阅读历史错误");
    }
    
    self.currentVC = currenVC;
    if (self.loadSuccess){
        self.loadSuccess(currenVC);
    }
    if (sucess) {
        sucess();
    }
}
/**
 * 预加载
 */
- (void)advanceLoadChapters {
    NSInteger index = self.currentIndex;
    NSMutableArray* chapters = [NSMutableArray array];
    NSInteger adLoadChapters = (BRUserDefault.adLoadChapters>=1?:3)<= 20?:20;
    for (NSInteger i = 0; i < adLoadChapters; i++) {
        ++index;
        if (index < self.chaptersArray.count){
            [chapters addObject:self.chaptersArray[index]];
        }
    }
    
    if (chapters.count >= 1 && _bookModel.sitesArray.count > 0){
        for (BRChapterDetail *item in chapters) {

            BRSite *site = [self.bookModel.sitesArray objectAtIndex:(self.bookModel.siteIndex.integerValue >= self.bookModel.sitesArray.count ? self.bookModel.sitesArray.count -1 : self.bookModel.siteIndex.integerValue)];
            [BRChapterDetail getChapterContentWithBookId:_bookModel.bookId chapterId:item.chapterId.integerValue siteId:site.siteId.longLongValue sucess:^(BRChapterDetail * _Nonnull chapterDetail) {
                
            } failureBlock:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}

/// 加载指定章节的内容
/// @param model 章节
/// @param isNext 加载的是否为下一章
/// @param recordText 阅读记录值
- (void)loadChapterTextWith:(BRChapter*)model
                     isNext:(BOOL)isNext
                 recordText:(NSString*)recordText
                     sucess:(nullable void (^)(void))sucess {
   
       
   if (!model){
       if (self.loadFail){
           self.loadFail([NSError errorWithDescription:@"暂无章节信息"]);
       }
       return;
   }
   
    BRSite *site = [self.sitesArray objectAtIndex:(self.bookModel.siteIndex.integerValue >= self.sitesArray.count ? self.sitesArray.count-1 : self.bookModel.siteIndex.integerValue)];
    if (site) {
        if (self.startLoadBlock) {
            self.startLoadBlock();
        }
        CFDebugLog(@"请求章节内容中……");
        kWeakSelf(self)
        [BRChapterDetail getChapterContentWithBookId:_bookModel.bookId chapterId:model.chapterId.integerValue siteId:site.siteId.longValue sucess:^(BRChapterDetail * _Nonnull chapterDetail) {
            kStrongSelf(self)
             /* 改变记录值*/
             self.currentChapter = model;
             self.currentChapterDetail = chapterDetail;
             self.currentIndex = [self.chaptersArray indexOfObject:self.currentChapter];
             if (self.currentIndex >= self.chaptersArray.count) {
                   self.currentIndex = 0;
             }
               
           /* 分页*/
           @try {
               CFDebugLog(@"分页中……");
               [self pagingContentVCsWithisNext:isNext recordText:recordText sucess:^{
                   if (sucess) {
                       sucess();
                   }
               }];
           } @catch (NSException *exception) {
               CFDebugLog(@"书本分页失败");
               if (self.loadFail){
                   self.loadFail([NSError errorWithDescription:@"书本分页失败"]);
               }
           }
           
           /* 预加载*/
           [self advanceLoadChapters];
        } failureBlock:^(NSError * _Nonnull error) {
            CFDebugLog(@"请求章节失败……");
             if (self.loadFail){
                 self.loadFail(error);
             }
        }];
    } else {
        if (self.loadFail){
            self.loadFail([NSError errorWithDescription:@"暂无源信息"]);
        }
        return;
    }
}

/// 记载上一章节 加载完成后默认在前一章节的最后一页
- (void)loadBeforeChapterText {
    CFDebugLog(@"加载上一章节");
    NSInteger index = self.currentIndex;
    if (index - 1>=0 && index - 1<self.chaptersArray.count){
        BRChapter* model = self.chaptersArray[index - 1];
        [self loadChapterTextWith:model isNext:NO recordText:nil sucess:^{
            
        }];
    }else{
        CFDebugLog(@"chaptersArray.count=%ld,index=%ld",self.chaptersArray.count,index);
        if (self.hubFail){
            self.hubFail(@"已经是第一章了");
        }
    }
}

- (void)loadBeforeChapterTextSucess:(nullable void (^)(void))sucess {
    CFDebugLog(@"加载上一章节");
    NSInteger index = self.currentIndex;
    if (index - 1>=0 && index - 1<self.chaptersArray.count){
        BRChapter* model = self.chaptersArray[index - 1];
        [self loadChapterTextWith:model isNext:NO recordText:nil sucess:^{
            if (sucess) {
                sucess();
            }
        }];
    }else{
        CFDebugLog(@"chaptersArray.count=%ld,index=%ld",self.chaptersArray.count,index);
        if (self.hubFail){
            self.hubFail(@"已经是第一章了");
        }
    }
}


///  加载下一章节,加载完成后默认显示后一章节的第一页
- (void)loadNextChapterTextSucess:(nullable void (^)(void))sucess {
    CFDebugLog(@"加载下一章节");
    NSInteger index = self.currentIndex;
    
    if (index + 1 >= 0 && index + 1<self.chaptersArray.count){
        BRChapter *model = self.chaptersArray[index + 1];
        [self loadChapterTextWith:model isNext:YES recordText:nil sucess:^{
            if (sucess) {
                sucess();
            }
        }];
    }else{
        CFDebugLog(@"chaptersArray.count = %ld,index = %ld",self.chaptersArray.count,index);
        if (self.hubFail){
            self.hubFail(@"已经是最后一章了");
        }
    }
}

- (BRSite *)getTheLastSite {
    BRSite *lastSite = [_sitesArray firstObject];
    for (BRSite *site in _sitesArray) {
        if (lastSite.oid.intValue > site.oid.intValue) {
            
        } else {
            lastSite = site;
        }
    }
    return lastSite;
}

#pragma mark - BookReadVMDelegate
- (NSInteger)getCurrentChapterIndex {
    return self.currentIndex;
}

- (NSInteger)getCurrentVCIndexWithVC:(UIViewController*)vc {
    NSInteger index = self.currentIndex;
    
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

- (void)getNewAllChapters {
    [self loadChaptersWithRecord:NO];
}

- (void)loadChapterWithIndex:(NSInteger)index {
    if (index < self.chaptersArray.count){
        BRChapter* model = self.chaptersArray[index];
        [self loadChapterTextWith:model isNext:YES recordText:nil sucess:^{
            
        }];
    }else{
        [self loadChapterTextWith:self.chaptersArray.lastObject isNext:YES recordText:nil sucess:^{
            
        }];
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

- (void)startLoadData:(block)block {
    self.startLoadBlock = block;
}

- (void)loadChapters:(block)block {
    self.loadChaptersSuccess = block;
}

/* 获取前一个界面*/
- (UIViewController *)viewControllerBeforeViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided {
    /* UIPageViewController在UIPageViewControllerTransitionStyleScroll模式下,会连续向前/向后请求两次
       目前的方法只能是通过标记暂时解决一下这个问题,
     */
    static NSInteger scrollTimes;
    
    NSArray *textArr = [_dataDict objectForKey:self.currentChapter.chapterId];
    
    NSInteger index;
    if (doubleSided){
        index = self.currentVCIndex;
        scrollTimes = 0;
    }else {
        index = self.currentVCIndex;
//        index = [self.vcArray indexOfObject:viewController];
    }
    
    /* 返回背面*/
    if (doubleSided && [viewController isKindOfClass:[BRBookReadContenViewController class]]){
        self.currentVC = (BRBookReadContenViewController *)viewController;
        return self.currentVC.backVC;
    }
    
    if (index - 1 >=0 && index - 1 < textArr.count){
        /* 记录阅读历史*/
        self.currentVCIndex = index - 1;
        [self saveBookRecordWithPageIndex:index - 1];
        
        BRBookReadContenViewController* vc = (BRBookReadContenViewController* )[self.readViewReusePool dequeueReusebleView];
        if (!vc) {
            vc = [[BRBookReadContenViewController alloc] initWithText:textArr[self.currentIndex] chapterName:self.currentChapter.name totalNum:textArr.count index:self.currentVCIndex +1];
            [self.readViewReusePool addUsingView:vc];
        }
        vc.text = textArr[self.currentVCIndex];
        vc.chapterName = self.currentChapter.name;
        vc.totalNum = textArr.count;
        vc.index = self.currentVCIndex +1;
        
        self.currentVC = vc;

        return self.currentVC;
    }
    if (!doubleSided && index==0){
//        if (scrollTimes > 0)
            [self loadBeforeChapterText];
//        else{
//            BRBookReadContenViewController* lv = self.vcArray.firstObject;
//            BRBookReadContenViewController* newV = [[BRBookReadContenViewController alloc] initWithText:lv.text chapterName:lv.chapterName totalNum:lv.totalNum index:lv.index];
//            return newV;
//
//        }
        
//        scrollTimes = 1;
        return nil;
    }
    /* 网络加载*/
    [self loadBeforeChapterText];
    return nil;
}

/* 获取后一界面*/
- (UIViewController*)viewControllerAfterViewController:(UIViewController *)viewController DoubleSided:(BOOL)doubleSided {
    NSArray *textArr = [_dataDict objectForKey:self.currentChapter.chapterId];
    NSInteger index = self.currentVCIndex;
    
    /* 返回背面*/
    if (doubleSided && [viewController isKindOfClass:[BRBookReadContenViewController class]]){
        self.currentVC = (BRBookReadContenViewController*)viewController;
        return self.currentVC.backVC;
    }
    
    if (index + 1 >= 0 && index + 1 < textArr.count){
        /* 记录阅读历史*/
        self.currentVCIndex = index + 1;
        [self saveBookRecordWithPageIndex:index + 1];
        BRBookReadContenViewController* vc = (BRBookReadContenViewController* )[self.readViewReusePool dequeueReusebleView];
        if (!vc) {
            vc = [[BRBookReadContenViewController alloc] initWithText:textArr[self.currentVCIndex] chapterName:self.currentChapter.name totalNum:textArr.count index:self.currentVCIndex +1];
            [self.readViewReusePool addUsingView:vc];
        }
        vc.text = textArr[self.currentVCIndex];
        vc.chapterName = self.currentChapter.name;
        vc.totalNum = textArr.count;
        vc.index = self.currentVCIndex +1;
        
        self.currentVC = vc;
        
        return self.currentVC;
    } else {
        self.isChangeChapter = YES;
        [self loadNextChapterTextSucess:^{
            self.currentVCIndex = 0;
            self.isChangeChapter = NO;
        }];
        return nil;
        
    }
    
}

- (NSArray<UIViewController *> *)viewModelGetAllVCs {
    return @[];
}

- (NSMutableDictionary *)viewModelGetAllDataDict {
    return _dataDict;
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

- (nonnull BRBookInfoModel *)BRBookInfoModel {
    return _bookModel;
}


@end
