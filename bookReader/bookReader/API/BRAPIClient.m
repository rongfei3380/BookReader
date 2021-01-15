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
#import "CFCustomMacros.h"
#import "NSError+BRError.h"

@implementation BRAPIClient

//- (instancetype)init{
//    if (self = [super init]) {
//        
//        self.baseUrl = @"http://www.skcy.top/index.php?m=api&c=apimap&a=";
//    
//        
//    }
//    return self;
//}

/**
 负责发送API请求
 */
- (void)sendRequest:(CFHTTPRequestMethod)method
               path:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))successBlock
            failure:(CFAPIClientFailureBlock)failureBlock {
    
    
    
    void (^requestSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
    
    requestSuccessBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        [CFBaseResponseErrorParser parseResponseDataForError:&error withData:responseObject];
        if (error) {
            CFDebugLog(@"path!!! = %@", path);
            CFDebugLog(@"error JSON!!! = %@", responseObject);
            
            if (failureBlock) {
                failureBlock(error);
            }
        } else if (successBlock) {
            NSDictionary *dataDic = (NSDictionary *)responseObject;
            //TODO. 特殊处理
            
            CFDebugLog(@"path!!! = %@", path);
            CFDebugLog(@"retVal!!! = %@", responseObject);
            
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            DDLogDebug(@"retVal Str !!! = %@", jsonStr);
            
            
            successBlock(task, responseObject);
        }
    };
    
    void (^requestFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
    requestFailureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        CFDebugLog(@"error PATH!!! = %@", path);
        CFDebugLog(@"error!!! = %@", error.description);

    };

    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    switch (method) {
        case CFHTTPRequestMethodGET: {
            
            [manager GET:path parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (requestSuccessBlock) {
                    requestSuccessBlock(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (requestFailureBlock) {
                    requestFailureBlock(task, error);
                }
            }];
        }
            break;
        case CFHTTPRequestMethodPOST: {
            [manager POST:path parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (requestSuccessBlock) {
                    requestSuccessBlock(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (requestFailureBlock) {
                    requestFailureBlock(task, error);
                }
            }];
        }
            break;
        case CFHTTPRequestMethodPUT: {
            [manager PUT:path parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                requestSuccessBlock(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (requestFailureBlock) {
                    requestFailureBlock(task, error);
                }
            }];
        }
            break;
        case CFHTTPRequestMethodDELETE: {
            [manager DELETE:path parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            break;
        default:
            break;
    }
}

/**
 附加基本的请求参数，每个请求都会带  根据实际业务需求处理
 */
- (void)appendRequestParameters:(NSMutableDictionary *)parameters {
    
}

- (void)responseObject:(id  _Nullable)responseObject
       sessionDataTask:(NSURLSessionDataTask * _Nonnull)task
               success:(CFAPIClientSuccessBlock)successBlock
               failure:(CFAPIClientFailureBlock)failureBlock {
    NSError *error = nil;
    [CFBaseResponseErrorParser parseResponseDataForError:&error withData:responseObject];
    if (error) {
        CFDebugLog(@"path!!! = %@", task.originalRequest.URL);
        CFDebugLog(@"error JSON!!! = %@", responseObject);

        if (failureBlock) {
            failureBlock(error);
        }
    } else {
        NSDictionary *dataDic = (NSDictionary *)responseObject;
        NSDictionary *dict = [dataDic objectForKey:@"data"];
        if (!responseObject) {
            NSError *error = [NSError errorWithDescription:@"responseObject is nil"];
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            CFDebugLog(@"path!!! = %@", task.originalRequest.URL);
            CFDebugLog(@"retVal Str !!! = %@", jsonStr);
            successBlock(dict);
        }
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
     

    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
       
    [manager GET:@"" parameters:paramDic headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=getlist" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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
         
      [paramDic setObject:[NSNumber numberWithInteger:bookid] forKey:@"id"];
    if (isSelect) {
         [paramDic setObject:@1 forKey:@"is_select"];
    } else {
         [paramDic setObject:@0 forKey:@"is_select"];
    }
     

    
      BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
         

      [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=getbookinfo" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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

- (void)getBookInfosShelfWithBookids:(NSString *)ids
                              sucess:(CFAPIClientSuccessBlock)successBlock
                        failureBlock:(CFAPIClientFailureBlock)failureBlock{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            
    [paramDic setObject:ids forKey:@"id"];
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];

     [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=getbooklistinfo" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=getcategory" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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
                         isOver:(int)isOver
                           page:(NSInteger)page
                           size:(NSInteger)size
                         sucess:(CFAPIClientSuccessBlock)successBlock
                   failureBlock:(CFAPIClientFailureBlock)failureBlock {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (isOver == 0) {
        [paramDic setObject:[NSNumber numberWithInt:isOver] forKey:@"is_over"];
    } else if (isOver == 1)  {
        [paramDic setObject:[NSNumber numberWithInt:isOver] forKey:@"is_over"];
    }
    if(categoryId > 0) {
        [paramDic setObject:[NSNumber numberWithInteger:categoryId] forKey:@"id"];
    }
    [paramDic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [paramDic setObject:[NSNumber numberWithInteger:size] forKey:@"size"];
    
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    
    [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=getcategorybook" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"url: %@", task.currentRequest.URL);
        
       [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , (long)page] forKey:@"page"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , (long)size] forKey:@"size"];
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    
    [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=select" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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

- (void)getChaptersListWithBookId:(NSNumber *)bookId
                           siteId:(NSInteger)siteId
                         sortType:(NSInteger)sortType
                           sucess:(CFAPIClientSuccessBlock)successBlock
                     failureBlock:(CFAPIClientFailureBlock)failureBlock {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"id"];
    
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , (long)siteId] forKey:@"yuan_id"];
    
    if (sortType) {
        [paramDic setObject:@"asc" forKey:@"sort"];
    } else {
        [paramDic setObject:@"desc" forKey:@"sort"];
    }
    
    
//    [self sendRequest:CFHTTPRequestMethodGET path:@"" parameters:paramDic success:^(id  _Nonnull dataBody) {
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    
    [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=getbookpage" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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
        CFDebugLog(@"error : %@", error);
    }];
}

- (void)getChapterContentWithBookId:(NSNumber *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(CFAPIClientSuccessBlock)successBlock
                       failureBlock:(CFAPIClientFailureBlock)failureBlock{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"bookid"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , chapterId] forKey:@"chapterid"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , siteId] forKey:@"siteid"];
    
    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    
    [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=getbookcontent" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        kDISPATCH_ON_GLOBAL_QUEUE_DEFAULT(^{
            [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
                 if (successBlock) {
                     kdispatch_main_sync_safe(^{
                         successBlock(dataBody);
                     });
                 }
             } failure:^(NSError * _Nonnull error) {
                 if (failureBlock){
                     kdispatch_main_sync_safe(^{
                         failureBlock(error);
                     });
                 }
             }];
        });
       
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

    
    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    
    [manager GET:@"https://www.skcy.top/index.php?m=api&c=apimap&a=source" parameters:paramDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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

- (void)getRecommendSuccess:(CFAPIClientSuccessBlock)successBlock
               failureBlock:(CFAPIClientFailureBlock)failureBlock {
    
        BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
       
       [manager GET:@"http://www.skcy.top/index.php?m=api&c=apimap&a=getrecommend" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
          [self responseObject:responseObject sessionDataTask:task success:^(id  _Nonnull dataBody) {
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
