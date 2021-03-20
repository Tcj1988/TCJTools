//
//  TCJRequestConst.h
//  TCJNetworkingDemo
//
//  Created by 310537065@qq.com on 03/18/2021.
//  Copyright © 2017年 310537065@qq.com. All rights reserved.
//

#ifndef TCJRequestConst_h
#define TCJRequestConst_h
@class TCJURLRequest,TCJBatchRequest;

/**
 用于标识不同类型的请求
 默认为重新请求.  default:TCJRequestTypeRefresh
 */
typedef NS_ENUM(NSInteger,TCJApiType) {
    /**
     重新请求:   不读取缓存，不存储缓存
     没有缓存需求的，单独使用
     */
    TCJRequestTypeRefresh,
    /**
     重新请求:   不读取缓存，但存储缓存
     可以与 TCJRequestTypeCache 配合使用
     */
    TCJRequestTypeRefreshAndCache,
    /**
     读取缓存:   有缓存,读取缓存--无缓存，重新请求并存储缓存
     可以与TCJRequestTypeRefreshAndCache 配合使用
     */
    TCJRequestTypeCache,
    /**
     重新请求：  上拉加载更多业务，不读取缓存，不存储缓存
     用于区分业务 可以不用
     */
    TCJRequestTypeRefreshMore,
};
/**
 HTTP 请求类型.
 默认为GET请求.   default:TCJMethodTypeGET
 */
typedef NS_ENUM(NSInteger,TCJMethodType) {
    /**GET请求*/
    TCJMethodTypeGET,
    /**POST请求*/
    TCJMethodTypePOST,
    /**Upload请求*/
    TCJMethodTypeUpload,
    /**DownLoad请求*/
    TCJMethodTypeDownLoad,
    /**PUT请求*/
    TCJMethodTypePUT,
    /**PATCH请求*/
    TCJMethodTypePATCH,
    /**DELETE请求*/
    TCJMethodTypeDELETE
};
/**
 请求参数的格式.
 默认为JSON.   default:TCJJSONRequestSerializer
 */
typedef NS_ENUM(NSUInteger, TCJRequestSerializerType) {
    /** 设置请求参数为JSON格式*/
    TCJJSONRequestSerializer,
    /** 设置请求参数为二进制格式*/
    TCJHTTPRequestSerializer,
};
/**
 返回响应数据的格式.
 默认为JSON.  default:TCJJSONResponseSerializer
 */
typedef NS_ENUM(NSUInteger, TCJResponseSerializerType) {
    /** 设置响应数据为JSON格式*/
    TCJJSONResponseSerializer,
    /** 设置响应数据为二进制格式*/
    TCJHTTPResponseSerializer
};
/**
 相同的URL 多次网络请求,请求结果没有响应的时候。可以指定使用第一次或最后一次请求结果。
 如果请求结果响应了，会终止此过程。
 默认不做任何操作.  default:TCJResponseKeepNone
 */
typedef NS_ENUM(NSUInteger, TCJResponseKeepType) {
    /** 不进行任何操作*/
    TCJResponseKeepNone,
    /** 使用第一次请求结果*/
    TCJResponseKeepFirst,
    /** 使用最后一次请求结果*/
    TCJResponseKeepLast
};
/**
 操作状态
 */
typedef NS_ENUM(NSUInteger, TCJDownloadState) {
    /** 开始请求*/
    TCJDownloadStateStart,
    /** 暂停请求*/
    TCJDownloadStateStop,
};
/**
 *  当前网络的状态值，
 */
typedef NS_ENUM(NSInteger, TCJNetworkReachabilityStatus) {
    /** Unknown*/
    TCJNetworkReachabilityStatusUnknown          = -1,
    /** NotReachable*/
    TCJNetworkReachabilityStatusNotReachable     = 0,
    /** WWAN*/
    TCJNetworkReachabilityStatusViaWWAN          = 1,
    /** WiFi*/
    TCJNetworkReachabilityStatusViaWiFi          = 2,
};

//==================================================
/** 请求配置的Block */
typedef void (^TCJRequestConfigBlock)(TCJURLRequest * _Nullable request);
/** 请求成功的Block */
typedef void (^TCJRequestSuccessBlock)(id _Nullable responseObject,TCJURLRequest * _Nullable request);
/** 请求失败的Block */
typedef void (^TCJRequestFailureBlock)(NSError * _Nullable error);
/** 请求进度的Block */
typedef void (^TCJRequestProgressBlock)(NSProgress * _Nullable progress);
/** 请求完成的Block 无论成功和失败**/
typedef void (^TCJRequestFinishedBlock)(id _Nullable responseObject,NSError * _Nullable error,TCJURLRequest * _Nullable request);
//==================================================
/** 批量请求配置的Block */
typedef void (^TCJBatchRequestConfigBlock)(TCJBatchRequest * _Nonnull batchRequest);
/** 批量请求 全部完成的Block 无论成功和失败*/
typedef void (^TCJBatchRequestFinishedBlock)(NSArray * _Nullable responseObjects,NSArray<NSError *> * _Nullable errors,NSArray<TCJURLRequest *> *_Nullable requests);
//==================================================
/** 请求 处理逻辑的方法 Block */
typedef void (^TCJRequestProcessBlock)(TCJURLRequest * _Nullable request,id _Nullable __autoreleasing * _Nullable setObject);
/** 响应 处理逻辑的方法 Block */
typedef id _Nullable (^TCJResponseProcessBlock)(TCJURLRequest * _Nullable request, id _Nullable responseObject, NSError * _Nullable __autoreleasing * _Nullable error);
/** 错误 处理逻辑的方法 Block */
typedef void (^TCJErrorProcessBlock)(TCJURLRequest * _Nullable request, NSError * _Nullable error);
//==================================================
/** Request协议*/
@protocol TCJURLRequestDelegate <NSObject>
@required
/** 请求成功的 代理方法*/
- (void)request:(TCJURLRequest *_Nullable)request successForResponseObject:(id _Nullable)responseObject ;
@optional
/** 请求失败的 代理方法*/
- (void)request:(TCJURLRequest *_Nullable)request failedForError:(NSError *_Nullable)error;
/** 请求进度的 代理方法*/
- (void)request:(TCJURLRequest *_Nullable)request forProgress:(NSProgress * _Nullable)progress;
/** 请求完成的 代理方法 无论成功和失败**/
- (void)request:(TCJURLRequest *_Nullable)request finishedForResponseObject:(id _Nullable)responseObject forError:(NSError *_Nullable)error ;
/** 批量请求 全部完成的 代理方法，无论成功和失败*/
- (void)requests:(NSArray<TCJURLRequest *> *_Nullable)requests batchFinishedForResponseObjects:(NSArray * _Nullable) responseObjects errors:(NSArray<NSError *> * _Nullable)errors;
@end

#endif /* TCJRequestConst_h */
