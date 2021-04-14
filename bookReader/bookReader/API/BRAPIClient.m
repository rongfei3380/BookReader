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
#import <CommonCrypto/CommonCrypto.h>

@interface BRAPIClient ()

@property(nonatomic, strong) BRHTTPSessionManager *sessionManagerManager;

@end

@implementation BRAPIClient


/// String's md5 hash.
static NSString *_BRNSStringMD5(NSString *string) {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0],  result[1],  result[2],  result[3],
                result[4],  result[5],  result[6],  result[7],
                result[8],  result[9],  result[10], result[11],
                result[12], result[13], result[14], result[15]
            ];
}


- (instancetype)init{
    if (self = [super init]) {
        
        self.baseUrl = @"https://api.21skcy.com:16888";
        
//        _configuration = [CFBaseAPIClient defaultURLSessionConfiguration];
//
        _sessionManagerManager = [[BRHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]];
////
//        _requestSerializer = [AFJSONRequestSerializer serializer];
//        _httpSessionManager.requestSerializer = _requestSerializer;
//
//        _responseSerializer = [AFJSONResponseSerializer serializer];
//        _httpSessionManager.responseSerializer = _responseSerializer;
        
    }
    return self;
}

/**
 负责发送API请求
 */
- (NSURLSessionDataTask *)sendRequest:(CFHTTPRequestMethod)method
               path:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(CFAPIClientSuccessBlock)successBlock
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
            CFDebugLog(@"path!!! = %@", path);
            CFDebugLog(@"retVal!!! = %@", responseObject);
            
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            DDLogDebug(@"retVal Str !!! = %@", jsonStr);
        }
    };
    
    void (^requestFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
    requestFailureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        CFDebugLog(@"error PATH!!! = %@", path);
        CFDebugLog(@"error!!! = %@", error.description);

    };

    // 开启 url 加密
    {
        NSInteger timestamp = [NSDate date].timeIntervalSince1970;
        NSString *key = @"21skcy2021";
        NSString *codeStr = [NSString stringWithFormat:@"%@%ld/%@", key, timestamp, path];
        NSString *md5hashStr = _BRNSStringMD5(codeStr);
        path = [NSString stringWithFormat:@"%ld/%@/%@", timestamp, md5hashStr, path];
    }
//    BRHTTPSessionManager* manager = [BRHTTPSessionManager sharedManager];
    switch (method) {
        case CFHTTPRequestMethodGET: {
            
            return [_sessionManagerManager GET:path parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
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
            return  [_sessionManagerManager POST:path parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
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
            return  [_sessionManagerManager PUT:path parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                requestSuccessBlock(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (requestFailureBlock) {
                    requestFailureBlock(task, error);
                }
            }];
        }
            break;
        case CFHTTPRequestMethodDELETE: {
            return   [_sessionManagerManager DELETE:path parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            break;
        default:
            return nil;
            break;
    }
}

/**
 附加基本的请求参数，每个请求都会带  根据实际业务需求处理
 */
- (void)appendRequestParameters:(NSMutableDictionary *)parameters {
    
}

- (NSURLSessionDataTask *)getRankListWithType:(NSInteger)type
                       page:(NSInteger)page
                       size:(NSInteger)size
                    success:(CFAPIClientSuccessBlock)successBlock
               failureBlock:(CFAPIClientFailureBlock)failureBlock{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSString *typeStr = nil;
    switch (type) {
        case 1:{
            typeStr = @"renqi";
        }
            break;
        case 2:{
            typeStr = @"shoucang";
        }
            break;
        case 3:{
            typeStr = @"xinshu";
        }
            break;
        case 4:{
            typeStr = @"wanjie";
        }
            break;
            
        default:
            break;
    }
       
//    [paramDic setObject:[NSString stringWithFormat:@"%ld" , type] forKey:@"type"];
    [paramDic setObject:[NSString stringWithFormat:@"%@" , typeStr] forKey:@"type"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , page] forKey:@"page"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , size] forKey:@"size"];
     

    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/tops.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getbookinfoWithBookId:(NSInteger)bookid
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
     
    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/info.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getBookInfosShelfWithBookids:(NSString *)ids
                              sucess:(CFAPIClientSuccessBlock)successBlock
                        failureBlock:(CFAPIClientFailureBlock)failureBlock{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            
    [paramDic setObject:ids forKey:@"id"];
    
    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/userCollect.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getBookCategorySucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock{
    
    
    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/category.json" parameters:nil success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getBookListWithCategory:(NSInteger)categoryId
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
    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/list.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}


- (NSURLSessionDataTask *)searchBookWithName:(NSString *)name
                      page:(NSInteger)page
                      size:(NSInteger)size
                    sucess:(CFAPIClientSuccessBlock)successBlock
              failureBlock:(CFAPIClientFailureBlock)failureBlock{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:name forKey:@"name"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , (long)page] forKey:@"page"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , (long)size] forKey:@"size"];
    
    return [self sendRequest:CFHTTPRequestMethodPOST path:@"appapi/search.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getChaptersListWithBookId:(NSNumber *)bookId
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

    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/chapters.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getChapterContentWithBookId:(NSNumber *)bookId
                          chapterId:(NSInteger)chapterId
                             siteId:(NSInteger)siteId
                             sucess:(CFAPIClientSuccessBlock)successBlock
                       failureBlock:(CFAPIClientFailureBlock)failureBlock{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"bookid"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , chapterId] forKey:@"chapterid"];
    [paramDic setObject:[NSString stringWithFormat:@"%ld" , siteId] forKey:@"siteid"];
    
    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/chapterInfo.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
             successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getSiteListWithBookId:(NSNumber *)bookId
                       sucess:(CFAPIClientSuccessBlock)successBlock
                 failureBlock:(CFAPIClientFailureBlock)failureBlock {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"bookid"];

    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/source.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)getRecommendSuccess:(CFAPIClientSuccessBlock)successBlock
               failureBlock:(CFAPIClientFailureBlock)failureBlock {
    
    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/home.json" parameters:nil success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)addbookWithBookId:(NSNumber *)bookId
                                     sucess:(CFAPIClientSuccessBlock)successBlock
                               failureBlock:(CFAPIClientFailureBlock)failureBlock {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
       
    [paramDic setObject:bookId forKey:@"id"];

    return [self sendRequest:CFHTTPRequestMethodGET path:@"appapi/mark.json" parameters:paramDic success:^(id  _Nonnull dataBody) {
        if (successBlock) {
            successBlock(dataBody);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
}

@end
