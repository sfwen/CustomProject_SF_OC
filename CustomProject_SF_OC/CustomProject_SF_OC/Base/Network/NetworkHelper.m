//
//  NetworkHelper.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "NetworkHelper.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "NetworkHelper+Manager.h"
#import "CacheManager.h"

#define ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define MESSAGE_ERROR [NSError errorWithDomain:@"com.sf.Networking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:ERROR_IMFORMATION}]

static NSMutableArray   *requestTasksPool;

static NSDictionary     *headers;

static SFNetworkStatus    networkStatus;

static NSTimeInterval   requestTimeout = 30.f;

@implementation NetworkHelper

#pragma mark - manager
+ (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    
    [self checkNetworkStatus];
    kBasicURL_Article = [[NetworkEnvironmentManager shareManager] judgeNetwork:networkEnvironment];
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[YQCacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[CacheManager shareManager] clearLRUCache];
    
    return manager;
}

+ (AFURLSessionManager *)URLSessionManager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFURLSessionManager * sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    
    sessionManager.responseSerializer = responseSerializer;
    
    [self checkNetworkStatus];
//    kBasicURL_Store = @"http://api.yuntujk.com";//[[NetworkEnvironmentManager shareManager] judgeNetwork:networkEnvironment];
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[YQCacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[CacheManager shareManager] clearLRUCache];
    
    return sessionManager;
}

#pragma mark - 检查网络
+ (void)checkNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = SFNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = SFNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = SFNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = SFNetworkStatusReachableViaWiFi;
                break;
            default:
                networkStatus = SFNetworkStatusUnknown;
                break;
        }
    }];
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [NSMutableArray array];
    });
    
    return requestTasksPool;
}

#pragma mark - get
+ (URLSessionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary *)params
                   progressBlock:(GetProgress)progressBlock
                    successBlock:(ResponseSuccessBlock)successBlock
                       failBlock:(ResponseFailBlock)failBlock {
    //将session拷贝到堆中，block内部才可以获取得到session
    __block URLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == SFNetworkStatusNotReachable) {
        if (failBlock) failBlock(MESSAGE_ERROR);
        return session;
    }

    NSString * requestURL = [NSString stringWithFormat:@"%@%@", kBasicURL_Article, url];
    if ([url hasPrefix:@"http"]) {
        requestURL = url;
    }
    //默认数据的添加
    NSMutableDictionary * requestParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [requestParams setObject:kRevisionControlName forKey:@"vertype"];
    
    NSLog(@"请求地址：\n%@\n请求参数：\n%@\n", requestURL, [NSString dictionaryToJSONString:requestParams]);
    
    id responseObj = [[CacheManager shareManager] getCacheResponseObjectWithRequestUrl:requestURL params:requestParams];
    
    if (responseObj && cache) {
        if (successBlock) successBlock([[NetworkEnvironmentManager shareManager] processData:responseObj], YES);
    }
    
    session = [manager GET:requestURL
                parameters:requestParams
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount,
                                                       downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      id result = [[NetworkEnvironmentManager shareManager] processData:responseObject];
                      if (successBlock) successBlock(result, NO);
                      
                      if (cache && result) [[CacheManager shareManager] cacheResponseObject:result requestUrl:requestURL params:requestParams];
                      
                      [[self allTasks] removeObject:session];
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failBlock) failBlock(error);
                      [[self allTasks] removeObject:session];
                      
                  }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        //取消新请求
        [session cancel];
        return session;
    } else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        URLSessionTask * oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

+ (URLSessionTask *)body_getWithUrl:(NSString *)url
                     refreshRequest:(BOOL)refresh
                              cache:(BOOL)cache
                             params:(NSDictionary *)params
                      progressBlock:(GetProgress)progressBlock
                       successBlock:(ResponseSuccessBlock)successBlock
                          failBlock:(ResponseFailBlock)failBlock {
    //将session拷贝到堆中，block内部才可以获取得到session
    __block URLSessionTask *session = nil;
    
    if (networkStatus == SFNetworkStatusNotReachable) {
        if (failBlock) failBlock(MESSAGE_ERROR);
        return session;
    }
    
    AFURLSessionManager * manager = [self URLSessionManager];
    
    NSString * requestURL = [NSString stringWithFormat:@"%@%@", kBasicURL_Store, url];
    NSLog(@"请求地址：\n%@\n请求参数：\n%@\n", requestURL, [NSString dictionaryToJSONString:params]);
    
    id responseObj = [[CacheManager shareManager] getCacheResponseObjectWithRequestUrl:requestURL params:params];
    if (responseObj && cache) {
        if (successBlock) successBlock([[NetworkEnvironmentManager shareManager] processData:responseObj], YES);
    }
    
    
    NSMutableURLRequest * request = [self initUrl:requestURL requestType:@"GET" body:params];
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) progressBlock(downloadProgress.completedUnitCount,
                                         downloadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            id result = [[NetworkEnvironmentManager shareManager] processData:responseObject];
            if (successBlock) successBlock(result, NO);
            
            if (cache && result) [[CacheManager shareManager] cacheResponseObject:result requestUrl:requestURL params:params];
            
            [[self allTasks] removeObject:session];
        } else {
            if (failBlock) failBlock(error);
            [[self allTasks] removeObject:session];
        }
    }] resume];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        //取消新请求
        [session cancel];
        return session;
    } else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        URLSessionTask * oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

+ (NSMutableURLRequest *)initUrl:(NSString *)url requestType:(NSString *)requestType body:(NSDictionary *)params {
    NSData * body = nil;
    if (params.count > 0) {
        NSString * pagramStr = [NSString dictionaryToJSONString:params];
        body = [pagramStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    
//    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url, NULL, NULL, kCFStringEncodingUTF8 ));
    NSString *charactersToEscape = @"#[]@!$'()*+,;\"<>%{}|^~`";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [[url description] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:requestType URLString:encodedUrl parameters:nil error:nil];
    request.timeoutInterval = requestTimeout;
    
    NSMutableDictionary * headerDict = [[NSMutableDictionary alloc] initWithDictionary:headers];
    [headerDict setObject:@"application/json;charset=UTF-8" forKey:@"Content-Type"];
    
    for (NSString *key in headerDict.allKeys) {
        if (headerDict[key] != nil) {
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    [request setHTTPBody:body];
    
    return request;
}

#pragma mark - post
+ (URLSessionTask *)postWithUrl:(NSString *)url
                   refreshRequest:(BOOL)refresh
                            cache:(BOOL)cache
                           params:(NSDictionary *)params
                    progressBlock:(PostProgress)progressBlock
                     successBlock:(ResponseSuccessBlock)successBlock
                        failBlock:(ResponseFailBlock)failBlock {
    __block URLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == SFNetworkStatusNotReachable) {
        if (failBlock) failBlock(MESSAGE_ERROR);
        return session;
    }
    
    NSString * requestURL = [NSString stringWithFormat:@"%@%@", kBasicURL_Article, url];
    
    id responseObj = [[CacheManager shareManager] getCacheResponseObjectWithRequestUrl:requestURL params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj, YES);
    }
    
    session = [manager POST:requestURL
                 parameters:params
                   progress:^(NSProgress * _Nonnull uploadProgress) {
                       if (progressBlock) progressBlock(uploadProgress.completedUnitCount,
                                                        uploadProgress.totalUnitCount);
                       
                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       if (successBlock) successBlock(responseObject, NO);
                       
                       if (cache) [[CacheManager shareManager] cacheResponseObject:responseObject requestUrl:requestURL params:params];
                       
                       if ([[self allTasks] containsObject:session]) {
                           [[self allTasks] removeObject:session];
                       }
                       
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       if (failBlock) failBlock(error);
                       [[self allTasks] removeObject:session];
                       
                   }];
    
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        [session cancel];
        return session;
    }else {
        URLSessionTask * oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

#pragma mark - 文件上传
+ (URLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(UploadProgressBlock)progressBlock
                           successBlock:(ResponseSuccessBlock)successBlock
                              failBlock:(ResponseFailBlock)failBlock {
    __block URLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == SFNetworkStatusNotReachable) {
        if (failBlock) failBlock(MESSAGE_ERROR);
        return session;
    }
    
    NSString * requestURL = [NSString stringWithFormat:@"%@%@", kBasicURL_Article, url];
    
    session = [manager POST:requestURL
                 parameters:nil
  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      NSString *fileName = nil;
      
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = @"yyyyMMddHHmmss";
      
      NSString *day = [formatter stringFromDate:[NSDate date]];
      
      fileName = [NSString stringWithFormat:@"%@.%@",day,type];
      
      [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
      
  } progress:^(NSProgress * _Nonnull uploadProgress) {
      if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
      
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if (successBlock) successBlock(responseObject, NO);
      [[self allTasks] removeObject:session];
      
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (failBlock) failBlock(error);
      [[self allTasks] removeObject:session];
      
  }];
    
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}

#pragma mark - 多文件上传
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                     progressBlock:(UploadProgressBlock)progressBlock
                      successBlock:(MultUploadSuccessBlock)successBlock
                         failBlock:(MultUploadFailBlock)failBlock {
    
    if (networkStatus == SFNetworkStatusNotReachable) {
        if (failBlock) failBlock(@[MESSAGE_ERROR]);
        return nil;
    }
    
    NSString * requestURL = [NSString stringWithFormat:@"%@%@", kBasicURL_Article, url];
    
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    NSInteger count = datas.count;
    for (int i = 0; i < count; i++) {
        __block URLSessionTask *session = nil;
        
        dispatch_group_enter(uploadGroup);
        
        session = [self uploadFileWithUrl:requestURL
                                 fileData:datas[i]
                                     type:type name:name
                                 mimeType:mimeTypes
                            progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                                if (progressBlock) progressBlock(bytesWritten,
                                                                 totalBytes);
                                
                            } successBlock:^(id response, BOOL cache) {
                                [responses addObject:response];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                                
                            } failBlock:^(NSError *error) {
                                NSError *Error = [NSError errorWithDomain:requestURL code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i]}];
                                
                                [failResponse addObject:Error];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                            }];
        
        [session resume];
        
        if (session) [sessions addObject:session];
    }
    
    [[self allTasks] addObjectsFromArray:sessions];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (responses.count > 0) {
            if (successBlock) {
                successBlock([responses copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
    });
    
    return [sessions copy];
}

#pragma mark - 下载
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(DownloadProgress)progressBlock
                         successBlock:(DownloadSuccessBlock)successBlock
                            failBlock:(DownloadFailBlock)failBlock {
    NSString *type = nil;
    NSArray *subStringArr = nil;
    __block URLSessionTask *session = nil;
    
    NSString * requestURL = [NSString stringWithFormat:@"%@%@", kBasicURL_Article, url];
    
    NSURL *fileUrl = [[CacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:requestURL];
    
    if (fileUrl) {
        if (successBlock) successBlock(fileUrl);
        return nil;
    }
    
    if (![requestURL isEqualToString:kBasicURL_Article]) {
        subStringArr = [requestURL componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }
    
    AFHTTPSessionManager *manager = [self manager];
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session = [manager GET:requestURL
                parameters:nil
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (successBlock) {
                          NSData *dataObj = (NSData *)responseObject;
                          
                          [[CacheManager shareManager] storeDownloadData:dataObj requestUrl:requestURL];
                          
                          NSURL *downFileUrl = [[CacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:requestURL];
                          
                          successBlock(downFileUrl);
                      }
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failBlock) {
                          failBlock (error);
                      }
                  }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}

#pragma mark - other method
+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(URLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    NSString * requestURL = [NSString stringWithFormat:@"%@%@", kBasicURL_Article, url];
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(URLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:requestURL]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}

+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}

+ (NSString *)dictToJsonByData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NetworkHelper (Cache)

+ (NSUInteger)totalCacheSize {
    return [[CacheManager shareManager] totalCacheSize];
}

+ (NSUInteger)totalDownloadDataSize {
    return [[CacheManager shareManager] totalDownloadDataSize];
}

+ (void)clearDownloadData {
    [[CacheManager shareManager] clearDownloadData];
}

+ (NSString *)getDownDirectoryPath {
    return [[CacheManager shareManager] getDownDirectoryPath];
}

+ (NSString *)getCacheDiretoryPath {
    
    return [[CacheManager shareManager] getCacheDiretoryPath];
}

+ (void)clearTotalCache {
    [[CacheManager shareManager] clearTotalCache];
}

@end
