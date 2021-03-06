//
//  NSDate+TCJExtension.h
//  Time
//
//  Created by tangchangjiang on 2019/6/26.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (TCJExtension)
/// 判断是否是本周
- (BOOL)isThisWeek;

/// 判断是否是本周更早
- (BOOL)isThisWeekEarlier;

/// 判断是否是本周晚些
- (BOOL)isThisWeekLater;

/// 判断是否是下一周或者更远
- (BOOL)isNextWeekOrLater;

/// 判断是否是上一周或者更早
- (BOOL)isLastWeekOrEarlier;

/// 判断是否是昨天或更早
- (BOOL)isYesterdayOrEarlier;

/// 判断是否是明天或更晚
- (BOOL)isTomorrowOrLater;

/// 判断是否是前天
- (BOOL)isTheDayBeforeYesterday;

/// 判断是否是昨天
- (BOOL)isYesterDay;

/// 判断是否是今天
- (BOOL)isToday;

/// 判断是否是明天
- (BOOL)isTomorrow;

/// 判断是否是后天
- (BOOL)isTheDayAfterTomorrow;

/// 转换成年月日（其他补0）
- (NSDate *)convertDefinitionToDate;

/// 转换标准时间 eg: 2019-06-26 14:36 星期三
- (NSString *)convertToStandardDateFormat;

/// 转换本星期标准时间 星期四 13:57
- (NSString *)convertToStandardThisWeekDateFormat;

/// 转换成标准前天、昨天、今天、明天、后天时间
- (NSString *)convertToStandardRecentlyDateFormat;

/// 转换成时间
- (NSString *)convertToStandardTimeDateFormat;

/// 转换成标准时间（不带星期）
- (NSString *)convertToStandardNormalDateFormat;

/// 转换成YYYY-MM-DD HH:MM:SS格式时间
- (NSString *)convertToStandardYYYYMMDDHHMMSSDateFormat;

/// 转换成YYYY-MM-DD
- (NSString *)convertToStandardYYYYMMDDDateFormat;

/// 转换成YYYYMMDDHHMMSS
- (NSString *)convertToYYYYMMDDHHMMSSDateFormat;

/// 指定日期是星期几，1表示一周的第一天周日
+ (int)weekdayByDate:(NSDate *)date;

/// 输出周几
+ (NSString *)weekdayInChineseByDate:(NSDate *)date;

/// 指定时间往前推多少天
+ (NSDate *)dateWithDays:(NSUInteger)days beforDate:(NSDate *)date;

/// 指定时间往后推多少天
+ (NSDate *)dateWithDays:(NSUInteger)days afterDate:(NSDate *)date;

/// 获取某个时间点前多少天的总集合
+ (NSArray *)dayNamesAtDays:(NSInteger)days beforDate:(NSDate *)date;

/// 获取年
+ (int)yearByDate:(NSDate *)date;

/// 获取月
+ (int)monthByDate:(NSDate *)date;

/// 获取日
+ (int)dayByDate:(NSDate *)date;

/// 该日期处于一年中的第几周
+ (int)weekOfYearByDate:(NSDate *)date;

/// 获取当前的时间HH:mm
+ (NSString *)getCurrentDateHHMM;

/// 获取当前的时间yyyyMMdd HH:mm
+(NSString *)getCurrentDateYYYYMMDDHHMM;

/// 获取当前的时间yyyyMMdd
+(NSString *)getCurrentDateYYYYMMDD;

/// 获取指定的时间yyyyMMdd
+(NSString *)getDateYYYYMMDD:(NSDate *)date;

/// 该月有多少天
+ (int)daysInMonthByDate:(NSDate *)date;

/// eg:2019-06-27 13:31:53
+ (NSString *)convertToyyyMMddHHmmssString:(NSDate *)date;

+ (NSDate *)convertDateFromString:(NSString*)dateSting;

+ (NSDate *)stringToDate:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
