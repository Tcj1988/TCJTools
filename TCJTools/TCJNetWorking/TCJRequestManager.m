//
//  TCJRequestManager.m
//  TCJNetworkingDemo
//
//  Created by 310537065@qq.com on 03/18/2021.
//  Copyright © 2017年 310537065@qq.com. All rights reserved.
//

#import "TCJRequestManager.h"
#import "TCJCacheManager.h"
#import "TCJURLRequest.h"
#import "NSString+TCJUTF8Encoding.h"

NSString *const _response =@"_response";
NSString *const _isCache =@"_isCache";
NSString *const _cacheKey =@"_cacheKey";
NSString *const _filePath =@"_filePath";
NSString *const cj_downloadTempPath =@"AppTempDownload";
NSString *const cj_downloadPath =@"AppDownload";
@implementation TCJRequestManager

#pragma mark - 插件
+ (void)setupBaseConfig:(void(^)(TCJConfig *config))block{
    TCJConfig *config=[[TCJConfig alloc]init];
    config.consoleLog=NO;
    block ? block(config) : nil;
    [[TCJRequestEngine defaultEngine] setupBaseConfig:config];
}

+ (void)setRequestProcessHandler:(TCJRequestProcessBlock)requestHandler{
    [TCJRequestEngine defaultEngine].requestProcessHandler=requestHandler;
}

+ (void)setResponseProcessHandler:(TCJResponseProcessBlock)responseHandler{
    [TCJRequestEngine defaultEngine].responseProcessHandler = responseHandler;
}

+ (void)setErrorProcessHandler:(TCJErrorProcessBlock)errorHandler{
    [TCJRequestEngine defaultEngine].errorProcessHandler=errorHandler;
}

#pragma mark - 配置请求
+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config target:(id<TCJURLRequestDelegate>_Nonnull)target{
    return [self requestWithConfig:config progress:nil success:nil failure:nil finished:nil target:target];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock)config success:(TCJRequestSuccessBlock)success{
    return [self requestWithConfig:config progress:nil success:success failure:nil finished:nil];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock)config failure:(TCJRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:nil failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock)config finished:(TCJRequestFinishedBlock)finished{
    return [self requestWithConfig:config progress:nil success:nil failure:nil finished:finished];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock)config success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock _Nonnull )config  success:(TCJRequestSuccessBlock _Nullable )success failure:(TCJRequestFailureBlock _Nullable )failure finished:(TCJRequestFinishedBlock _Nullable )finished{
    return [self requestWithConfig:config progress:nil success:success failure:failure finished:finished];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock)config progress:(TCJRequestProgressBlock)progress success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:progress success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock)config progress:(TCJRequestProgressBlock)progress success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure finished:(TCJRequestFinishedBlock)finished{
    return [self requestWithConfig:config progress:progress success:success failure:failure finished:finished target:nil];
}

+ (NSUInteger)requestWithConfig:(TCJRequestConfigBlock)config progress:(TCJRequestProgressBlock)progress success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure finished:(TCJRequestFinishedBlock)finished target:(id<TCJURLRequestDelegate>)target{
    TCJURLRequest *request=[[TCJURLRequest alloc]init];
    config ? config(request) : nil;
    return [self sendRequest:request progress:progress success:success failure:failure finished:finished target:target];
}

#pragma mark - 配置批量请求
+ (TCJBatchRequest *)requestBatchWithConfig:(TCJBatchRequestConfigBlock)config target:(id<TCJURLRequestDelegate>_Nonnull)target{
    return [self requestBatchWithConfig:config progress:nil success:nil failure:nil finished:nil target:target];
}

+ (TCJBatchRequest *)requestBatchWithConfig:(TCJBatchRequestConfigBlock)config success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure finished:(TCJBatchRequestFinishedBlock)finished{
    return [self requestBatchWithConfig:config progress:nil success:success failure:failure finished:finished];
}

+ (TCJBatchRequest *)requestBatchWithConfig:(TCJBatchRequestConfigBlock)config progress:(TCJRequestProgressBlock)progress success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure finished:(TCJBatchRequestFinishedBlock)finished{
    return [self requestBatchWithConfig:config progress:progress success:success failure:failure finished:finished target:nil];
}

+ (TCJBatchRequest *)requestBatchWithConfig:(TCJBatchRequestConfigBlock)config progress:(TCJRequestProgressBlock)progress success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure finished:(TCJBatchRequestFinishedBlock)finished target:(id<TCJURLRequestDelegate>)target{
    TCJBatchRequest *batchRequest=[[TCJBatchRequest alloc]init];
    config ? config(batchRequest) : nil;
    if (batchRequest.requestArray.count==0)return nil;
    [batchRequest.responseArray removeAllObjects];
    [batchRequest.requestArray enumerateObjectsUsingBlock:^(TCJURLRequest *request , NSUInteger idx, BOOL *stop) {
        [batchRequest.responseArray addObject:[NSNull null]];
        [self sendRequest:request progress:progress success:success failure:failure finished:^(id responseObject, NSError *error,TCJURLRequest *request) {
            [batchRequest onFinishedRequest:request response:responseObject error:error finished:finished];
        }target:target];
    }];
    return batchRequest;
}

#pragma mark - 发起请求
+ (NSUInteger)sendRequest:(TCJURLRequest *)request progress:(TCJRequestProgressBlock)progress success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure finished:(TCJRequestFinishedBlock)finished target:(id<TCJURLRequestDelegate>)target{
    
    if ([request.url isEqualToString:@""]||request.url==nil)return 0;
    
    [self configBaseWithRequest:request progress:progress success:success failure:failure finished:finished target:target];
    
    id obj=nil;
    if ([TCJRequestEngine defaultEngine].requestProcessHandler) {
        [TCJRequestEngine defaultEngine].requestProcessHandler(request,&obj);
        if (obj) {
            [self successWithResponse:nil responseObject:obj request:request];
            return 0;
        }
    }
    
    NSURLSessionTask * task=[[TCJRequestEngine defaultEngine]objectRequestForkey:request.url];
    if (request.keepType==TCJResponseKeepFirst&&task) {
        return 0;
    }
    if (request.keepType==TCJResponseKeepLast&&task) {
        [self cancelRequest:task.taskIdentifier];
    }

    NSUInteger identifier=[self startSendRequest:request];
    [[TCJRequestEngine defaultEngine]setRequestObject:request.task forkey:request.url];
    return identifier;
}

+ (NSUInteger)startSendRequest:(TCJURLRequest *)request{
    if (request.methodType==TCJMethodTypeUpload) {
       return [self sendUploadRequest:request];
    }else if (request.methodType==TCJMethodTypeDownLoad){
       return [self sendDownLoadRequest:request];
    }else{
       return [self sendHTTPRequest:request];
    }
}

+ (NSUInteger)sendUploadRequest:(TCJURLRequest *)request{
    return [[TCJRequestEngine defaultEngine] uploadWithRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(request:forProgress:)]) {
            [request.delegate request:request forProgress:uploadProgress];
        }
        request.progressBlock?request.progressBlock(uploadProgress):nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponse:task.response responseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request];
    }];
}

+ (NSUInteger)sendHTTPRequest:(TCJURLRequest *)request{
    if (request.apiType==TCJRequestTypeRefresh||request.apiType==TCJRequestTypeRefreshMore) {
        return [self dataTaskWithHTTPRequest:request];
    }else{
        NSString *key = [self keyWithParameters:request];
        if ([[TCJCacheManager sharedInstance]cacheExistsForKey:key]&&request.apiType==TCJRequestTypeCache){
            [self getCacheDataForKey:key request:request];
            return 0;
        }else{
            return [self dataTaskWithHTTPRequest:request];
        }
    }
}

+ (NSUInteger)dataTaskWithHTTPRequest:(TCJURLRequest *)request{
    return [[TCJRequestEngine defaultEngine]dataTaskWithMethod:request progress:^(NSProgress * _Nonnull cj_progress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(request:forProgress:)]) {
            [request.delegate request:request forProgress:cj_progress];
        }
        request.progressBlock ? request.progressBlock(cj_progress) : nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponse:task.response responseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request];
    }];
}

+ (NSUInteger)sendDownLoadRequest:(TCJURLRequest *)request{
    if (request.downloadState==TCJDownloadStateStart) {
        [[TCJCacheManager sharedInstance]createDirectoryAtPath:[self AppDownloadPath]];
        return [self downloadStartWithRequest:request];
    }else{
        return [self downloadStopWithRequest:request];
    }
}

+ (NSUInteger)downloadStartWithRequest:(TCJURLRequest*)request{
    NSString *AppDownloadTempPath=[self AppDownloadTempPath];
    NSData *resumeData;
    if ([[TCJCacheManager sharedInstance]cacheExistsForKey:request.url inPath:AppDownloadTempPath]) {
        resumeData=[[TCJCacheManager sharedInstance]getCacheDataForKey:request.url inPath:AppDownloadTempPath];
    }
    return [[TCJRequestEngine defaultEngine] downloadWithRequest:request resumeData:resumeData savePath:[self AppDownloadPath] progress:^(NSProgress * _Nullable downloadProgress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(request:forProgress:)]) {
            [request.delegate request:request forProgress:downloadProgress];
        }
        request.progressBlock?request.progressBlock(downloadProgress):nil;
    }completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [self failureWithError:error request:request];
        }else{
            [self successWithResponse:response responseObject:[filePath path] request:request];
            if ([[TCJCacheManager sharedInstance]cacheExistsForKey:request.url inPath:AppDownloadTempPath]) {
                [[TCJCacheManager sharedInstance]clearCacheForkey:request.url inPath:AppDownloadTempPath completion:nil];
            }
        }
    }];
}

+ (NSUInteger)downloadStopWithRequest:(TCJURLRequest*)request{
    NSURLSessionTask * task=[[TCJRequestEngine defaultEngine]objectRequestForkey:request.url];
    NSURLSessionDownloadTask *downloadTask=(NSURLSessionDownloadTask *)task;
    [downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        NSString *AppDownloadTempPath=[self AppDownloadTempPath];
        [[TCJCacheManager sharedInstance]createDirectoryAtPath:AppDownloadTempPath];
        [[TCJCacheManager sharedInstance] storeContent:resumeData forKey:request.url inPath:AppDownloadTempPath isSuccess:^(BOOL isSuccess) {
            if (request.consoleLog==YES) {
                NSLog(@"\n------------TCJNetworking------download info------begin------\n暂停下载请求，保存当前已下载文件进度\n-URLAddress-:%@\n-downloadFileDirectory-:%@\n------------TCJNetworking------download info-------end-------",request.url,AppDownloadTempPath);
            }
        }];
    }];
    [request setTask:downloadTask];
    [request setIdentifier:downloadTask.taskIdentifier];
    return request.identifier;
}

#pragma mark - 取消请求
+ (void)cancelRequest:(NSUInteger)identifier{
    [[TCJRequestEngine defaultEngine]cancelRequestByIdentifier:identifier];
}

+ (void)cancelBatchRequest:(TCJBatchRequest *)batchRequest{
    if (batchRequest.requestArray.count>0) {
        [batchRequest.requestArray enumerateObjectsUsingBlock:^(TCJURLRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.identifier>0) {
                [self cancelRequest:obj.identifier];
            }
        }];
    }
}

+ (void)cancelAllRequest{
    [[TCJRequestEngine defaultEngine]cancelAllRequest];
}

#pragma mark - 其他配置
+ (void)configBaseWithRequest:(TCJURLRequest *)request progress:(TCJRequestProgressBlock)progress success:(TCJRequestSuccessBlock)success failure:(TCJRequestFailureBlock)failure finished:(TCJRequestFinishedBlock)finished target:(id<TCJURLRequestDelegate>)target{
    [[TCJRequestEngine defaultEngine] configBaseWithRequest:request progressBlock:progress successBlock:success failureBlock:failure finishedBlock:finished target:target];
}

+ (NSString *)keyWithParameters:(TCJURLRequest *)request{
    id newParameters;
    if (request.filtrationCacheKey.count>0) {
        newParameters=[TCJRequestTool formaParameters:request.parameters filtrationCacheKey:request.filtrationCacheKey];
    }else{
        newParameters = request.parameters;
    }
    NSString *key=[NSString cj_stringUTF8Encoding:[NSString cj_urlString:request.url appendingParameters:newParameters]];
    [request setValue:key forKey:_cacheKey];
    return key;
}

+ (void)storeObject:(NSObject *)object request:(TCJURLRequest *)request{
    [[TCJCacheManager sharedInstance] storeContent:object forKey:request.cacheKey isSuccess:nil];
}

+ (id)responsetSerializerConfig:(TCJURLRequest *)request responseObject:(id)responseObject{
    if (request.responseSerializer==TCJHTTPResponseSerializer||request.methodType==TCJMethodTypeDownLoad||![responseObject isKindOfClass:[NSData class]]) {
        return responseObject;
    }else{
        NSError *serializationError = nil;
        NSData *data = (NSData *)responseObject;
        // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
        // See https://github.com/rails/rails/issues/1742
        BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
        if (data.length > 0 && !isSpace) {
            id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            return result;
        } else {
            return nil;
        }
    }
}

+ (void)successWithResponse:(NSURLResponse *)response responseObject:(id)responseObject request:(TCJURLRequest *)request{
    id result=[self responsetSerializerConfig:request responseObject:responseObject];
    if ([TCJRequestEngine defaultEngine].responseProcessHandler) {
        NSError *processError = nil;
        id newResult =[TCJRequestEngine defaultEngine].responseProcessHandler(request, result,&processError);
        if (newResult) {
            result = newResult;
        }
        if (processError) {
            [self failureWithError:processError request:request];
            return;
        }
    }
    if (request.apiType == TCJRequestTypeRefreshAndCache||request.apiType == TCJRequestTypeCache) {
        [self storeObject:responseObject request:request];
    }
    [request setValue:response forKey:_response];
    [request setValue:@(NO) forKey:_isCache];
    [self successWithCacheCallbackForResult:result forRequest:request];
}

+ (void)failureWithError:(NSError *)error request:(TCJURLRequest *)request{
    if (request.consoleLog==YES) {
        [self printfailureInfoWithError:error request:request];
    }
    if ([TCJRequestEngine defaultEngine].errorProcessHandler) {
        [TCJRequestEngine defaultEngine].errorProcessHandler(request, error);
    }
    if (request.retryCount > 0) {
        request.retryCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self startSendRequest:request];
        });
        return;
    }
    [self failureCallbackForError:error forRequest:request];
}

+ (void)getCacheDataForKey:(NSString *)key request:(TCJURLRequest *)request{
    [[TCJCacheManager sharedInstance]getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
        if (request.consoleLog==YES) {
            [self printCacheInfoWithkey:key filePath:filePath request:request];
        }
        id result=[self responsetSerializerConfig:request responseObject:data];
        if ([TCJRequestEngine defaultEngine].responseProcessHandler) {
            NSError *processError = nil;
            id newResult =[TCJRequestEngine defaultEngine].responseProcessHandler(request, result,&processError);
            if (newResult) {
                result = newResult;
            }
        }
        [request setValue:filePath forKey:_filePath];
        [request setValue:@(YES) forKey:_isCache];
        [self successWithCacheCallbackForResult:result forRequest:request];
    }];
}

+ (void)successWithCacheCallbackForResult:(id)result forRequest:(TCJURLRequest *)request{
    if (request.delegate&&[request.delegate respondsToSelector:@selector(request:successForResponseObject:)]) {
        [request.delegate request:request successForResponseObject:result];
    }
    if (request.delegate&&[request.delegate respondsToSelector:@selector(request:finishedForResponseObject:forError:)]) {
        [request.delegate request:request finishedForResponseObject:result forError:nil];
    }
    request.successBlock?request.successBlock(result, request):nil;
    request.finishedBlock?request.finishedBlock(result, nil,request):nil;
    [request cleanAllCallback];
    [[TCJRequestEngine defaultEngine] removeRequestForkey:request.url];
}

+ (void)failureCallbackForError:(NSError *)error forRequest:(TCJURLRequest *)request{
    if (request.delegate&&[request.delegate respondsToSelector:@selector(request:failedForError:)]) {
        [request.delegate request:request failedForError:error];
    }
    if (request.delegate&&[request.delegate respondsToSelector:@selector(request:finishedForResponseObject:forError:)]) {
        [request.delegate request:request finishedForResponseObject:nil forError:error];
    }
    request.failureBlock?request.failureBlock(error):nil;
    request.finishedBlock?request.finishedBlock(nil,error,request):nil;
    [request cleanAllCallback];
    [[TCJRequestEngine defaultEngine] removeRequestForkey:request.url];
}

#pragma mark - 获取网络状态
+ (BOOL)isNetworkReachable{
    return [TCJRequestEngine defaultEngine].networkReachability != 0;
}

+ (BOOL)isNetworkWiFi{
    return [TCJRequestEngine defaultEngine].networkReachability == 2;
}

+ (TCJNetworkReachabilityStatus)networkReachability{
    return [[TCJRequestEngine defaultEngine]networkReachability];
}

#pragma mark - 下载获取文件
+ (NSString *)getDownloadFileForKey:(NSString *)key{
    return [[TCJCacheManager sharedInstance]getDiskFileForKey:[key lastPathComponent] inPath:[self AppDownloadPath]];
}

+ (NSString *)AppDownloadPath{
    return [[[TCJCacheManager sharedInstance] TCJKitPath]stringByAppendingPathComponent:cj_downloadPath];
}

+ (NSString *)AppDownloadTempPath{
    return [[[TCJCacheManager sharedInstance] TCJKitPath]stringByAppendingPathComponent:cj_downloadTempPath];
}

#pragma mark - 打印log
+ (void)printCacheInfoWithkey:(NSString *)key filePath:(NSString *)filePath request:(TCJURLRequest *)request{
    NSString *responseStr=request.responseSerializer==TCJHTTPResponseSerializer ?@"HTTP":@"JOSN";
    if ([filePath isEqualToString:@"memoryCache"]) {
        NSLog(@"\n------------TCJNetworking------cache info------begin------\n-cachekey-:%@\n-cacheFileSource-:%@\n-responseSerializer-:%@\n-filtrationCacheKey-:%@\n------------TCJNetworking------cache info-------end-------",key,filePath,responseStr,request.filtrationCacheKey);
    }else{
        NSLog(@"\n------------TCJNetworking------cache info------begin------\n-cachekey-:%@\n-cacheFileSource-:%@\n-cacheFileInfo-:%@\n-responseSerializer-:%@\n-filtrationCacheKey-:%@\n------------TCJNetworking------cache info-------end-------",key,filePath,[[TCJCacheManager sharedInstance] getDiskFileAttributesWithFilePath:filePath],responseStr,request.filtrationCacheKey);
    }
}

+ (void)printfailureInfoWithError:(NSError *)error request:(TCJURLRequest *)request{
    NSLog(@"\n------------TCJNetworking------error info------begin------\n-URLAddress-:%@\n-retryCount-%ld\n-error code-:%ld\n-error info-:%@\n------------TCJNetworking------error info-------end-------",request.url,request.retryCount,error.code,error.localizedDescription);
}

@end
