//
//  NSString+TCJUTF8Encoding.h
//  TCJNetworkingDemo
//
//  Created by 310537065@qq.com on 03/18/2021.
//  Copyright © 2018年 310537065@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TCJUTF8Encoding)

/**
 *  UTF8
 *
 *  @param urlString 编码前的url字符串
 *  @return 返回 编码后的url字符串
 */
+ (NSString *)cj_stringUTF8Encoding:(NSString *)urlString;

/**
 *  url字符串与parameters参数的的拼接
 *
 *  @param urlString url字符串
 *  @param parameters parameters参数
 *  @return 返回拼接后的url字符串
 */
+ (NSString *)cj_urlString:(NSString *)urlString appendingParameters:(id)parameters;

@end

@interface TCJRequestTool : NSObject

/**
 *  参数过滤变动参数
 *
 *  @param parameters           参数
 *  @param filtrationCacheKey   需要过滤的参数
 *  @return 返回过滤后的参数
 */
+ (id)formaParameters:(id)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey;

@end
