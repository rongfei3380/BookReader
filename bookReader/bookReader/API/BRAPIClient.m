//
//  BRAPIClient.m
//  bookReader
//
//  Created by Jobs on 2020/6/4.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRAPIClient.h"
#import "BRHTTPSessionManager.h"
#import "CFBaseResponseErrorParser.h"

@implementation BRAPIClient

//- (instancetype)init{
//    if (self = [super init]) {
//        
//        self.baseUrl = @"http://www.oneoff.net/index.php?m=api&c=apimap&a=";
//    
//        
//    }
//    return self;
//}

- (void)responseObject:(id  _Nullable)responseObject
               success:(CFAPIClientSuccessBlock)successBlock
               failure:(CFAPIClientFailureBlock)failureBlock {
    NSError *error = nil;
    [CFBaseResponseErrorParser parseResponseDataForError:&error withData:responseObject];
    if (error) {
        NSLog(@"error JSON!!! = %@", responseObject);

        if (failureBlock) {
            failureBlock(error);
        }
    } else {
        NSDictionary *dataDic = (NSDictionary *)responseObject;
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"retVal Str !!! = %@", jsonStr);
        successBlock(dict);
    }
}

- (void)getRankListWithType:(NSInteger)type
                       page:(NSInteger)page
                       size:(NSInteger)size
                    success:(CFAPIClientSuccessBlock)successBlock
               failureBlock:(CFAPIClientFailureBlock)failureBlock{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , type] forKey:@"type"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , page] forKey:@"page"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , size] forKey:@"size"];
     

    BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
       

    [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=getlist" parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
            if (successBlock) {
                successBlock(dataBody);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failureBlock){
                failureBlock(error);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       if (failureBlock){
           failureBlock(error);
       }
       NSLog(@"error : %@", error);
    }];
}

- (void)getbookinfoWithBookId:(NSInteger)bookid
                     isSelect:(BOOL)isSelect
                       sucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock{
      NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
         
      [paramDic setObject:[NSString stringWithFormat:@"%ld" , bookid] forKey:@"id"];
      [paramDic setObject:[NSNumber numberWithBool:isSelect] forKey:@"is_select"];

    
      BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
         

      [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=getbookinfo" parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
              if (successBlock) {
                  NSDictionary *dict = (NSDictionary *)dataBody;
                  successBlock(dict);
              }
          } failure:^(NSError * _Nonnull error) {
              if (failureBlock){
                  failureBlock(error);
              }
          }];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failureBlock){
             failureBlock(error);
         }
         NSLog(@"error : %@", error);
      }];
}

- (void)getBookCategorySucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock{
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
    [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=getcategory" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
            if (successBlock) {
                successBlock(dataBody);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failureBlock){
                failureBlock(error);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       if (failureBlock){
           failureBlock(error);
       }
       NSLog(@"error : %@", error);
    }];
}

- (void)getBookListWithCategory:(NSInteger)categoryId
                           page:(NSInteger)page
                           size:(NSInteger)size
                         sucess:(CFAPIClientSuccessBlock)successBlock
                   failureBlock:(CFAPIClientFailureBlock)failureBlock {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:[NSNumber numberWithInteger:categoryId] forKey:@"id"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , page] forKey:@"page"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , size] forKey:@"size"];
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
    
    [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=getcategorybook" parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
            if (successBlock) {
                successBlock(dataBody);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failureBlock){
                failureBlock(error);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
        NSLog(@"error : %@", error);
    }];
}


- (void)searchBookWithName:(NSString *)name
                      page:(NSInteger)page
                      size:(NSInteger)size
                    sucess:(CFAPIClientSuccessBlock)successBlock
              failureBlock:(CFAPIClientFailureBlock)failureBlock{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:name forKey:@"name"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , page] forKey:@"page"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , size] forKey:@"size"];
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
    
    [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=select" parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
            if (successBlock) {
                successBlock(dataBody);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failureBlock){
                failureBlock(error);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
        NSLog(@"error : %@", error);
    }];
}

- (void)getChaptersListWithBookId:(NSString *)bookId
                           siteId:(NSInteger)siteId
                         sortType:(NSInteger)sortType
                           sucess:(CFAPIClientSuccessBlock)successBlock
                     failureBlock:(CFAPIClientFailureBlock)failureBlock {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"id"];
    
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , siteId] forKey:@"yuan_id"];
    
    if (sortType) {
        [paramDic setObject:@"asc" forKey:@"sort"];
    } else {
        [paramDic setObject:@"desc" forKey:@"sort"];
    }
    
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
    
    [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=getbookpage" parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
            if (successBlock) {
                successBlock(dataBody);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failureBlock){
                failureBlock(error);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
        NSLog(@"error : %@", error);
    }];
}

- (void)getChapterContentWithBookId:(NSString *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(CFAPIClientSuccessBlock)successBlock
                       failureBlock:(CFAPIClientFailureBlock)failureBlock{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"bookid"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , chapterId] forKey:@"chapterid"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , siteId] forKey:@"siteid"];
    
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
    
    [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=getbookcontent" parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
            if (successBlock) {
                successBlock(dataBody);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failureBlock){
                failureBlock(error);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
        NSLog(@"error : %@", error);
    }];
}

- (void)getSiteListWithBookId:(NSNumber *)bookId
                       sucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"bookid"];

    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager manager];
    
    [manager POST:@"http://www.oneoff.net/index.php?m=api&c=apimap&a=source" parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject success:^(id  _Nonnull dataBody) {
            if (successBlock) {
                successBlock(dataBody);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failureBlock){
                failureBlock(error);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
        NSLog(@"error : %@", error);
    }];
}

@end
