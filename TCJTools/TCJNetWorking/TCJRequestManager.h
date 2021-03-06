//
//  TCJRequestManager.h
//  TCJNetworkingDemo
//
//  Created by 310537065@qq.com on 03/18/2021.
//  Copyright © 2017年 310537065@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCJRequestEngine.h"

@class TCJConfig;

@interface TCJRequestManager : NSObject

/**
 *  公共配置方法
 *
 *  @param block           请求配置  Block
 */
+ (void)setupBaseConfig:(void(^_Nullable)(TCJConfig * _Nullable config))block;

/**
 *  插件机制
 *
 *  自定义 请求 处理逻辑的方法
 *  @param requestHandler        处理请求前的逻辑 Block
 */
+ (void)setRequestProcessHandler:(TCJRequestProcessBlock _Nullable )requestHandler;
/**
 *  插件机制
 *
 *  自定义 响应 处理逻辑的方法
 *  @param responseHandler       处理响应结果的逻辑 Block
 */
+ (void)setResponseProcessHandler:(TCJResponseProcessBlock _Nullable )responseHandler;
/**
 *  插件机制
 *
 *  自定义 错误 处理逻辑的方法
 *  @param errorHandler          处理响应结果的逻辑 Block
 */
+ (void)setErrorProcessHandler:(TCJErrorProcessBlock _Nullable )errorHandler;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param target           执行代理的对象
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config target:(id<TCJURLRequestDelegate>_Nonnull)target;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config success:(TCJRequestSuccessBlock _Nullable )success;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param failure          请求失败的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config failure:(TCJRequestFailureBlock _Nullable )failure;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param finished         请求完成的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config finished:(TCJRequestFinishedBlock _Nullable )finished;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config  success:(TCJRequestSuccessBlock _Nullable )success failure:(TCJRequestFailureBlock _Nullable )failure;

/**
 *  请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         请求完成的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config  success:(TCJRequestSuccessBlock _Nullable )success failure:(TCJRequestFailureBlock _Nullable )failure finished:(TCJRequestFinishedBlock _Nullable )finished;

/**
 *  请求方法 进度
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config  progress:(TCJRequestProgressBlock _Nullable )progress success:(TCJRequestSuccessBlock _Nullable )success failure:(TCJRequestFailureBlock _Nullable )failure;

/**
 *  请求方法 进度
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         请求完成的 Block
 *  @return identifier      请求标识符
 */
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull)config progress:(TCJRequestProgressBlock _Nullable )progress success:(TCJRequestSuccessBlock _Nullable )success failure:(TCJRequestFailureBlock _Nullable )failure finished:(TCJRequestFinishedBlock _Nullable )finished;

/**
 *  批量请求方法
 *
 *  @param config           请求配置  Block
 *  @param target           执行代理的对象
 *  @return identifier      请求标识符
 */
+ (TCJBatchRequest *_Nullable)requestBatchWithConfig:(TCJBatchRequestConfigBlock _Nonnull )config target:(id<TCJURLRequestDelegate>_Nonnull)target;

/**
 *  批量请求方法
 *
 *  @param config           请求配置  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         批量请求完成的 Block
 *  @return BatchRequest    批量请求对象
 */
+ (TCJBatchRequest *_Nullable)requestBatchWithConfig:(TCJBatchRequestConfigBlock _Nonnull )config success:(TCJRequestSuccessBlock _Nullable )success failure:(TCJRequestFailureBlock _Nullable )failure finished:(TCJBatchRequestFinishedBlock _Nullable )finished;

/**
 *  批量请求方法 进度
 *
 *  @param config           请求配置  Block
 *  @param progress         请求进度  Block
 *  @param success          请求成功的 Block
 *  @param failure          请求失败的 Block
 *  @param finished         批量请求完成的 Block
 *  @return BatchRequest    批量请求对象
 */
+ (TCJBatchRequest *_Nullable)requestBatchWithConfig:(TCJBatchRequestConfigBlock _Nonnull )config progress:(TCJRequestProgressBlock _Nullable )progress success:(TCJRequestSuccessBlock _Nullable )success failure:(TCJRequestFailureBlock _Nullable )failure finished:(TCJBatchRequestFinishedBlock _Nullable )finished;

/**
 *  取消单个请求任务
 *
 *  @param identifier         请求identifier
 */
+ (void)cancelRequest:(NSUInteger)identifier;

/**
 *  取消批量请求任务
 *  
 *  @param batchRequest       批量请求对象
 */
+ (void)cancelBatchRequest:(TCJBatchRequest *_Nullable)batchRequest;

/**
 *  取消所有请求任务 活跃的请求都会被取消
 */
+ (void)cancelAllRequest;

/**
 *  获取网络状态 是否可用
 */
+ (BOOL)isNetworkReachable;

/**
 *  是否为WiFi网络
 */
+ (BOOL)isNetworkWiFi;

/**
 *  当前网络的状态值，
 *  TCJNetworkReachabilityStatusUnknown      表示 `Unknown`，
 *  TCJNetworkReachabilityStatusNotReachable 表示 `NotReachable
 *  TCJNetworkReachabilityStatusViaWWAN      表示 `WWAN`
 *  TCJNetworkReachabilityStatusViaWiFi      表示 `WiFi`
 */
+ (TCJNetworkReachabilityStatus)networkReachability;

/**
 *  获取下载文件
 *
 *  @param  key                 一般为请求地址
 *  @return 获取下载文件
 */
+ (NSString *_Nullable)getDownloadFileForKey:(NSString *_Nonnull)key;

/**
 *  获取沙盒默认创建的AppDownload目录
 *
 *  @return Library/Caches/TCJKit/AppDownload路径
 */
+ (NSString *_Nonnull)AppDownloadPath;

@end

