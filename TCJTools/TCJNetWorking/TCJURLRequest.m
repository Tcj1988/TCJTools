//
//  TCJURLRequest.m
//  TCJNetworking
//
//  Created by 310537065@qq.com on 03/18/2021.
//  Copyright © 2016年 310537065@qq.com. All rights reserved.
//

#import "TCJURLRequest.h"
@implementation TCJURLRequest
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _requestSerializer=TCJJSONRequestSerializer;
    _responseSerializer=TCJJSONResponseSerializer;
    _methodType=TCJMethodTypeGET;
    _apiType=TCJRequestTypeRefresh;
    _retryCount=0;
    _identifier = 0;
    
    _isBaseServer=YES;
    _isBaseParameters=YES;
    _isBaseHeaders=YES;
    return self;
}

- (void)setRequestSerializer:(TCJRequestSerializerType)requestSerializer{
    _requestSerializer=requestSerializer;
    _isRequestSerializer=YES;
}

- (void)setResponseSerializer:(TCJResponseSerializerType)responseSerializer{
    _responseSerializer=responseSerializer;
    _isResponseSerializer=YES;
}

- (void)cleanAllCallback{
    _successBlock = nil;
    _failureBlock = nil;
    _finishedBlock = nil;
    _progressBlock = nil;
    _delegate=nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //  NSLog(@"undefinedKey:%@",key);
}

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

#pragma mark - 上传请求参数
- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData {
    TCJUploadData *formData = [TCJUploadData formDataWithName:name fileData:fileData];
    [self.uploadDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    TCJUploadData *formData = [TCJUploadData formDataWithName:name fileName:fileName mimeType:mimeType fileData:fileData];
    [self.uploadDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    TCJUploadData *formData = [TCJUploadData formDataWithName:name fileURL:fileURL];
    [self.uploadDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    TCJUploadData *formData = [TCJUploadData formDataWithName:name fileName:fileName mimeType:mimeType fileURL:fileURL];
    [self.uploadDatas addObject:formData];
}

#pragma mark - 懒加载

- (NSMutableArray<TCJUploadData *> *)uploadDatas {
    if (!_uploadDatas) {
        _uploadDatas = [[NSMutableArray alloc]init];
    }
    return _uploadDatas;
}

@end

#pragma mark - TCJBatchRequest
@interface TCJBatchRequest () {
    NSUInteger _batchRequestCount;
    BOOL _failed;
}
@end

@implementation TCJBatchRequest
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _batchRequestCount = 0;
    _requestArray = [NSMutableArray array];
    _responseArray = [NSMutableArray array];
    return self;
}
- (void)onFinishedRequest:(TCJURLRequest*)request response:(id)responseObject error:(NSError *)error finished:(TCJBatchRequestFinishedBlock _Nullable )finished{
    NSUInteger index = [_requestArray indexOfObject:request];
    if (responseObject) {
         [_responseArray replaceObjectAtIndex:index withObject:responseObject];
    }else{
         _failed = YES;
         if (error) {
             [_responseArray replaceObjectAtIndex:index withObject:error];
         }
    }
    _batchRequestCount++;
    if (_batchRequestCount == _requestArray.count) {
        if (!_failed) {
            if (request.delegate&&[request.delegate respondsToSelector:@selector(requests:batchFinishedForResponseObjects:errors:)]) {
                [request.delegate requests:_requestArray batchFinishedForResponseObjects:_responseArray errors:nil];
            }
            if (finished) {
                finished(_responseArray,nil,_requestArray);
            }
        }else{
            if (request.delegate&&[request.delegate respondsToSelector:@selector(requests:batchFinishedForResponseObjects:errors:)]) {
                [request.delegate requests:_requestArray batchFinishedForResponseObjects:nil errors:_responseArray];
            }
            if (finished) {
                finished(nil,_responseArray,_requestArray);
            }
        }
    }
}

@end

#pragma mark - TCJUploadData

@implementation TCJUploadData

+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData {
    TCJUploadData *formData = [[TCJUploadData alloc] init];
    formData.name = name;
    formData.fileData = fileData;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    TCJUploadData *formData = [[TCJUploadData alloc] init];
    formData.name = name;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    formData.fileData = fileData;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    TCJUploadData *formData = [[TCJUploadData alloc] init];
    formData.name = name;
    formData.fileURL = fileURL;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    TCJUploadData *formData = [[TCJUploadData alloc] init];
    formData.name = name;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    formData.fileURL = fileURL;
    return formData;
}
@end

#pragma mark - TCJConfig

@implementation TCJConfig
- (void)setRequestSerializer:(TCJRequestSerializerType)requestSerializer{
    _requestSerializer=requestSerializer;
    _isRequestSerializer=YES;
}

- (void)setResponseSerializer:(TCJResponseSerializerType)responseSerializer{
    _responseSerializer=responseSerializer;
    _isResponseSerializer=YES;
}

@end
