//
//  NetworkHelper.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/8.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkEnvironmentManager.h"

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, SFNetworkStatus) {
    /**
     *  未知网络
     */
    SFNetworkStatusUnknown             = 1 << 0,
    /**
     *  无法连接
     */
    SFNetworkStatusNotReachable        = 1 << 1,
    /**
     *  WWAN网络
     */
    SFNetworkStatusReachableViaWWAN    = 1 << 2,
    /**
     *  WiFi网络
     */
    SFNetworkStatusReachableViaWiFi    = 1 << 3
};

/**
 *  请求任务
 */
typedef NSURLSessionTask URLSessionTask;

/**
 *  成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^ResponseSuccessBlock) (id response, BOOL cache);

/**
 *  失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^ResponseFailBlock) (NSError *error);

/**
 *  下载进度
 *
 *  @param bytesRead              已下载的大小
 *  @param totalBytes                总下载大小
 */
typedef void (^DownloadProgress) (int64_t bytesRead,
                                  int64_t totalBytes);

/**
 *  下载成功回调
 *
 *  @param url                       下载存放的路径
 */
typedef void(^DownloadSuccessBlock) (NSURL *url);

/**
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytes                总上传大小
 */
typedef void(^UploadProgressBlock) (int64_t bytesWritten,
                                    int64_t totalBytes);

/**
 *  多文件上传成功回调
 *
 *  @param responses 成功后返回的数据
 */
typedef void(^MultUploadSuccessBlock) (NSArray *responses);

/**
 *  多文件上传失败回调
 *
 *  @param errors 失败后返回的错误信息
 */
typedef void(^MultUploadFailBlock) (NSArray *errors);

typedef DownloadProgress GetProgress;

typedef DownloadProgress PostProgress;

typedef ResponseFailBlock DownloadFailBlock;

@interface NetworkHelper : NSObject

/**
 *  正在运行的网络任务
 *
 *  @return task
 */
+ (NSArray *)currentRunningTasks;

/**
 *  配置请求头
 *
 *  @param httpHeader 请求头
 */
+ (void)configHttpHeader:(NSDictionary *)httpHeader;

/**
 *  取消GET请求
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
+ (void)cancleAllRequest;

/**
 *    设置超时时间
 *
 *  @param timeout 超时时间
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;

/**
 *  GET请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          是否刷新请求(遇到重复请求，若为YES，则会取消旧的请求，用新的请求，若为NO，则忽略新请求，用旧请求)
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (URLSessionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary *)params
                   progressBlock:(GetProgress)progressBlock
                    successBlock:(ResponseSuccessBlock)successBlock
                       failBlock:(ResponseFailBlock)failBlock;
+ (URLSessionTask *)body_getWithUrl:(NSString *)url
                     refreshRequest:(BOOL)refresh
                              cache:(BOOL)cache
                             params:(NSDictionary *)params
                      progressBlock:(GetProgress)progressBlock
                       successBlock:(ResponseSuccessBlock)successBlock
                          failBlock:(ResponseFailBlock)failBlock;

/**
 *  POST请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          解释同上
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (URLSessionTask *)postWithUrl:(NSString *)url
                   refreshRequest:(BOOL)refresh
                            cache:(BOOL)cache
                           params:(NSDictionary *)params
                    progressBlock:(PostProgress)progressBlock
                     successBlock:(ResponseSuccessBlock)successBlock
                        failBlock:(ResponseFailBlock)failBlock;

/**
 *  文件上传
 *
 *  @param url              上传文件接口地址
 *  @param data             上传文件数据
 *  @param type             上传文件类型
 *  @param name             上传文件服务器文件夹名
 *  @param mimeType         mimeType
 *  @param progressBlock    上传文件路径
 *    @param successBlock     成功回调
 *    @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (URLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(UploadProgressBlock)progressBlock
                           successBlock:(ResponseSuccessBlock)successBlock
                              failBlock:(ResponseFailBlock)failBlock;

/**
 *  多文件上传
 *
 *  @param url           上传文件地址
 *  @param datas         数据集合
 *  @param type          类型
 *  @param name          服务器文件夹名
 *  @param mimeTypes      mimeTypes
 *  @param progressBlock 上传进度
 *  @param successBlock  成功回调
 *  @param failBlock     失败回调
 *
 *  @return 任务集合
 */
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                     progressBlock:(UploadProgressBlock)progressBlock
                      successBlock:(MultUploadSuccessBlock)successBlock
                         failBlock:(MultUploadFailBlock)failBlock;

/**
 *  文件下载
 *
 *  @param url           下载文件接口地址
 *  @param progressBlock 下载进度
 *  @param successBlock  成功回调
 *  @param failBlock     下载回调
 *
 *  @return 返回的对象可取消请求
 */
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(DownloadProgress)progressBlock
                         successBlock:(DownloadSuccessBlock)successBlock
                            failBlock:(DownloadFailBlock)failBlock;

@end

@interface NetworkHelper (Cache)

/**
 *  获取缓存目录路径
 *
 *  @return 缓存目录路径
 */
+ (NSString *)getCacheDiretoryPath;

/**
 *  获取下载目录路径
 *
 *  @return 下载目录路径
 */
+ (NSString *)getDownDirectoryPath;

/**
 *  获取缓存大小
 *
 *  @return 缓存大小
 */
+ (NSUInteger)totalCacheSize;

/**
 *  清除所有缓存
 */
+ (void)clearTotalCache;

/**
 *  获取所有下载数据大小
 *
 *  @return 下载数据大小
 */
+ (NSUInteger)totalDownloadDataSize;

/**
 *  清除下载数据
 */
+ (void)clearDownloadData;

@end
