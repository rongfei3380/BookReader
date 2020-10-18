//
//  ViewController.m
//  bookReader
//
//  Created by Jobs on 2020/6/3.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "ViewController.h"
#import "BRAPIClient.h"
#import "BRBookInfoModel.h"
#import "BRBookCategory.h"
#import "BRChapterDetail.h"
#import "BRSite.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[BRAPIClient sharedInstance] getRankListWithType:1 page:0 size:10 success:^(id  _Nonnull dataBody) {
//
//    } failureBlock:^(NSError * _Nonnull error) {
//
//    }];
//    [BRBookInfoModel getbookinfoWithBookId:2253 isSelect:NO sucess:^(BRBookInfoModel *bookInfoModel) {
//        NSLog(@"getbookinfo : %@", bookInfoModel);
//    } failureBlock:^(NSError * _Nonnull error) {
//
//    }];
//
//    [BRBookCategory getBookCategorySucess:^(NSArray * _Nonnull maleCategoryes, NSArray * _Nonnull famaleCategory) {
//        NSLog(@"男性标签 ： %@", maleCategoryes);
//        NSLog(@"女性标签： %@", famaleCategory);
//    } failureBlock:^(NSError * _Nonnull error) {
//
//    }];

//    [[BRAPIClient sharedInstance] getBookCategorySucess:^(id  _Nonnull dataBody) {
//
//    } failureBlock:^(NSError * _Nonnull error) {
//
//    }];
//
//    [[BRAPIClient sharedInstance] getBookListWithCategory:7 page:0 size:10 sucess:^(id  _Nonnull dataBody) {
//
//    } failureBlock:^(NSError * _Nonnull error) {
//
//    }];
//    [[BRAPIClient sharedInstance] searchBookWithName:@"青春" page:0 size:10 sucess:^(id  _Nonnull dataBody) {
//        
//    } failureBlock:^(NSError * _Nonnull error) {
//        
//    }];
    [BRBookInfoModel searchBookWithName:@"青春" page:0 size:10 sucess:^(NSArray * _Nonnull recodes) {
        NSLog(@"青春搜索结果 ：%@", recodes);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
    
    [BRSite getSiteListWithBookId:@21231 sucess:^(NSArray * _Nonnull recodes) {
        NSLog(@"小说源 ： %@", recodes);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
    [BRChapter getChaptersListWithBookId:@"21231" siteId:58 sortType:1 sucess:^(NSArray * _Nonnull recodes) {
        NSLog(@"章节列表 ： %@", recodes);
    } failureBlock:^(NSError * _Nonnull error) {

    }];

    [BRChapterDetail getChapterContentWithBookId:@"21231" chapterId:130994 siteId:58 sucess:^(BRChapterDetail * _Nonnull chapter) {
        NSLog(@"章节 内容 ： %@", chapter);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
 
//    [[BRAPIClient sharedInstance] getChaptersListWithBookId:@"2253" siteId:54 sortType:1 sucess:^(id  _Nonnull dataBody) {
//        
//    } failureBlock:^(NSError * _Nonnull error) {
//        
//    }];
//    
//    [[BRAPIClient sharedInstance] getChapterContentWithBookId:@"2253" chapterId:15863 siteId:54 sucess:^(id  _Nonnull dataBody) {
//        
//    } failureBlock:^(NSError * _Nonnull error) {
//        
//    }];
}


@end
