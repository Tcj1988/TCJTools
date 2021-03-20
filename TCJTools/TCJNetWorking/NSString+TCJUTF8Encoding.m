//
//  NSString+TCJUTF8Encoding.m
//  TCJNetworkingDemo
//
//  Created by 310537065@qq.com on 03/18/2021.
//  Copyright © 2018年 310537065@qq.com. All rights reserved.
//

#import "NSString+TCJUTF8Encoding.h"
#import <UIKit/UIKit.h>
@implementation NSString (TCJUTF8Encoding)

+ (NSString *)cj_stringUTF8Encoding:(NSString *)urlString{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0){
        return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else{
        return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

+ (NSString *)cj_urlString:(NSString *)urlString appendingParameters:(id)parameters{
    if (parameters==nil) {
        return urlString;
    }else{
        NSString *parametersString;
        if ([parameters isKindOfClass:[NSDictionary class]]){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *key in parameters) {
                id obj = [parameters objectForKey:key];
                NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
                [array addObject:str];
            }
            parametersString = [array componentsJoinedByString:@"&"];
        }else{
            parametersString =[NSString stringWithFormat:@"%@",parameters] ;
        }
        return [urlString stringByAppendingString:[NSString stringWithFormat:@"?%@",parametersString]];
    }
}

@end

@implementation TCJRequestTool

+ (id)formaParameters:(id)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey{
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [mutableParameters removeObjectsForKeys:filtrationCacheKey];
        return [mutableParameters copy];
    }else {
        return parameters;
    }
}

@end
