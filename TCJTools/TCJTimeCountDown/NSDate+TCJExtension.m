//
//  NSDate+TCJExtension.m
//  Time
//
//  Created by tangchangjiang on 2019/6/26.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

#import "NSDate+TCJExtension.h"

@implementation NSDate (TCJExtension)
- (NSDate *)dateStartOfWeek
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];//monday is first day
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:- ((([components weekday] - [gregorian firstWeekday]) + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *componentsStripped = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents:componentsStripped];
    return beginningOfWeek;
}

// 判断是否是昨天或更早
- (BOOL)isYesterdayOrEarlier
{
    NSDate *yesterdayDefinitionDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
    NSDate *definitionDate = [self convertDefinitionToDate];
    if ([yesterdayDefinitionDate isEqualToDate:definitionDate]) {
        return YES;
    }
    
    NSDate *earlierDate = [definitionDate earlierDate:[NSDate date]];
    if (earlierDate == self) {
        return YES;
    }
    
    return NO;
}

// 判断是否是明天或更晚
- (BOOL)isTomorrowOrLater
{
    NSDate *tomorrowDefinitionDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    NSDate *definitionDate = [self convertDefinitionToDate];
    if ([tomorrowDefinitionDate isEqualToDate:definitionDate]) {
        return YES;
    }
    
    NSDate *laterdate = [definitionDate laterDate:tomorrowDefinitionDate];
    if (laterdate == self) {
        return YES;
    }
    return NO;
}

// 判断是否是下一周或者更远
- (BOOL)isNextWeekOrLater
{
    if (![self isThisWeek]) {
        NSDate *laterDate = [self laterDate:[NSDate date]];
        if (laterDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是上一周或者更早
- (BOOL)isLastWeekOrEarlier
{
    if (![self isThisWeek]) {
        NSDate *earlierDate = [self earlierDate:[NSDate date]];
        if (earlierDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是本周
- (BOOL)isThisWeek
{
    NSDate *thisWeekStartDay = [[NSDate date] dateStartOfWeek];
    if ([thisWeekStartDay isEqualToDate:[self dateStartOfWeek]]) {
        return YES;
    }
    return NO;
}

// 判断是否是本周更早
- (BOOL)isThisWeekEarlier
{
    if ([self isThisWeek]) {
        NSDate *earlierDate = [self earlierDate:[NSDate date]];
        if (earlierDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是本周晚些
- (BOOL)isThisWeekLater
{
    if ([self isThisWeek]) {
        NSDate *laterDate = [self laterDate:[NSDate date]];
        if (laterDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是前天
- (BOOL)isTheDayBeforeYesterday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*2]];
    NSDate *dayBeforeYesterday = [cal dateFromComponents:components];
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    if ([dayBeforeYesterday isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是昨天
- (BOOL)isYesterDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24]];
    NSDate *yesterday = [cal dateFromComponents:components];
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    if ([yesterday isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是今天
- (BOOL)isToday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    if ([today isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是明天
- (BOOL)isTomorrow
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:60*60*24]];
    NSDate *tomorrow = [cal dateFromComponents:components];
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    if ([tomorrow isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是后天
- (BOOL)isTheDayAfterTomorrow
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:60*60*24*2]];
    NSDate *dayAfterTomorrow = [cal dateFromComponents:components];
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    if ([dayAfterTomorrow isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 转换成年月日 (其他补0)
- (NSDate *)convertDefinitionToDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSDate *dateConverted = [cal dateFromComponents:components];
    return dateConverted;
}

// 转换标准时间
- (NSString *)convertToStandardDateFormat
{
    // eg: 2019-06-26 14:36 星期三
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger weekday = [components weekday];
    NSString *weekdayStr = nil;
    switch (weekday) {
        case 1:
            weekdayStr = @"星期日";
            break;
        case 2:
            weekdayStr = @"星期一";
            break;
        case 3:
            weekdayStr = @"星期二";
            break;
        case 4:
            weekdayStr = @"星期三";
            break;
        case 5:
            weekdayStr = @"星期四";
            break;
        case 6:
            weekdayStr = @"星期五";
            break;
        case 7:
            weekdayStr = @"星期六";
            break;
        default:
            break;
    }
    NSString *standarDateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d %@", (int)year, (int)month, (int)day, (int)hour, (int)minute, weekdayStr];
    return standarDateFormatStr;
}

// 转换本星期标准时间
- (NSString *)convertToStandardThisWeekDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger weekday = [components weekday];
    NSString *weekdayStr = nil;
    switch (weekday) {
        case 1:
            weekdayStr = @"星期日";
            break;
        case 2:
            weekdayStr = @"星期一";
            break;
        case 3:
            weekdayStr = @"星期二";
            break;
        case 4:
            weekdayStr = @"星期三";
            break;
        case 5:
            weekdayStr = @"星期四";
            break;
        case 6:
            weekdayStr = @"星期五";
            break;
        case 7:
            weekdayStr = @"星期六";
            break;
        default:
            return nil;
            break;
    }
    NSString *standarThisWeekDateFormatStr = [NSString stringWithFormat:@"%@ %02d:%02d", weekdayStr, (int)hour, (int)minute];
    return standarThisWeekDateFormatStr;
}

// 转换成时间
- (NSString *)convertToStandardTimeDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSString *timeDateFormatStr = [NSString stringWithFormat:@"%02d:%02d",(int)hour,(int)minute];
    return timeDateFormatStr;
}

// 转换成标准时间（不带星期）
- (NSString *)convertToStandardNormalDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSString *dateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute];
    return dateFormatStr;
}

// 转换成YYYY-MM-DD HH:MM:SS格式时间
- (NSString *)convertToStandardYYYYMMDDHHMMSSDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    NSString *standardDateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute, (int)second];    
    return standardDateFormatStr;
}

// 转换成YYYYMMDDHHMMSS
- (NSString *)convertToYYYYMMDDHHMMSSDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    NSString *standardDateFormatStr = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute, (int)second];
    return standardDateFormatStr;
}

// 转换成YYYY-MM-DD
- (NSString *)convertToStandardYYYYMMDDDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSString *standardDateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d", (int)year, (int)month, (int)day];    
    return standardDateFormatStr;
}

// 转换成标准前天、昨天、今天、明天、后天时间 今天 19:36
- (NSString *)convertToStandardRecentlyDateFormat
{
    NSString *dateStr = nil;
    if ([self isToday]) {
        dateStr = @"今天";
    }else if ([self isTomorrow]){
        dateStr = @"明天";
    }else if ([self isTheDayAfterTomorrow]){
        dateStr = @"后天";
    }else if ([self isYesterDay]){
        dateStr = @"昨天";
    }else if ([self isTheDayBeforeYesterday]){
        dateStr = @"前天";
    }else{
        NSLog(@"类型错误:%s",__FUNCTION__);
        return nil;
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSString *todayDateFormatStr = [NSString stringWithFormat:@"%@ %02d:%02d", dateStr, (int)hour, (int)minute];    
    return todayDateFormatStr;
}

+ (NSDateComponents *)dateComponentsByDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;
    return [calendar components:calendarUnit fromDate:date];
}

// 指定日期是星期几，1表示一周的第一天周日
+ (int)weekdayByDate:(NSDate *)date
{
    return (int)[[self dateComponentsByDate:date] weekday];
}

+ (NSString *)weekdayInChineseByDate:(NSDate *)date
{
    NSString *name = nil;
    NSInteger weekday = [NSDate weekdayByDate:date];
    switch (weekday) {
        case 1:
            name = @"周日";
            break;
        case 2:
            name = @"周一";
            break;
        case 3:
            name = @"周二";
            break;
        case 4:
            name = @"周三";
            break;
        case 5:
            name = @"周四";
            break;
        case 6:
            name = @"周五";
            break;
        case 7:
            name = @"周六";
            break;
        default:
            break;
    }
    return name;
}

// 指定时间往前推多少天
+ (NSDate *)dateWithDays:(NSUInteger)days beforDate:(NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSinceReferenceDate] - 86400 * days;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
}
// 指定时间往后推多少天
+ (NSDate *)dateWithDays:(NSUInteger)days afterDate:(NSDate *)date {
    
    NSTimeInterval interval = [date timeIntervalSinceReferenceDate] + 86400 * days;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
}

// 获取某个时间点前多少天的总集合
+ (NSArray *)dayNamesAtDays:(NSInteger)days beforDate:(NSDate *)date
{
    NSMutableArray *names = [NSMutableArray array];
    NSInteger currentMonthDay = [NSDate dayByDate:date];
    for (int i = (int)days - 1; i >= currentMonthDay; i--) {
        NSDate *date = [NSDate dateWithDays:i beforDate:[NSDate date]];
        NSInteger day = [NSDate dayByDate:date];
        [names addObject:[NSString stringWithFormat:@"%d",(int)day]];
    }
    
    for (int i = (int)currentMonthDay -1; i >= 0; i--) {
        NSDate *date = [NSDate dateWithDays:i beforDate:[NSDate date]];
        NSInteger day = [NSDate dayByDate:date];
        [names addObject:[NSString stringWithFormat:@"%d",(int)day]];
    }
    return names;
}

// 获取年
+ (int)yearByDate:(NSDate *)date
{
    return (int)[[self dateComponentsByDate:date] year];
}
// 获取月
+ (int)monthByDate:(NSDate *)date
{
    return (int)[[self dateComponentsByDate:date] month];
}
// 获取日
+ (int)dayByDate:(NSDate *)date
{
    return (int)[[self dateComponentsByDate:date] day];
}

// 该日期处于一年中的第几周
+ (int)weekOfYearByDate:(NSDate *)date
{
    return (int)[[self dateComponentsByDate:date] weekOfYear];
}

//获取当前的时间HH:mm
+ (NSString *)getCurrentDateHHMM
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:[NSDate date]];
}

//获取当前的时间yyyyMMdd HH:mm
+(NSString *)getCurrentDateYYYYMMDDHHMM
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd HH:mm"];
    return [formatter stringFromDate:[NSDate date]];
}

//获取当前的时间yyyyMMdd
+(NSString *)getCurrentDateYYYYMMDD
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:[NSDate date]];
}

//获取指定的时间yyyyMMdd
+(NSString *)getDateYYYYMMDD:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:date];
}

// 该月有多少天
+ (int)daysInMonthByDate:(NSDate *)date
{
    NSRange dayRange = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return (int)dayRange.length;
}

// 2019-06-27 13:31:53
+ (NSString *)convertToyyyMMddHHmmssString:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = ( NSCalendarUnitEra |
                                   NSCalendarUnitYear |
                                   NSCalendarUnitMonth |
                                   NSCalendarUnitDay |
                                   NSCalendarUnitWeekday |
                                   NSCalendarUnitHour |
                                   NSCalendarUnitMinute |
                                   NSCalendarUnitSecond);
    NSDateComponents *components = [cal components:calendarUnit fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    NSString *dateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute, (int)second];
    return dateFormatStr;
}

+ (NSDate *)convertDateFromString:(NSString *)dateSting
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSDate *date = [formatter dateFromString:dateSting];
    return date;
}

+ (NSDate *)stringToDate:(NSString *)dateString
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
@end
