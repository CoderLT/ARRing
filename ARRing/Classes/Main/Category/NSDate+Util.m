//
//  NSDate+Util.m
//  AT
//
//  Created by xiao6 on 14-10-13.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (NSDateString)

- (NSString *)stringWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:dateFormat];
    
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)dateSetTime:(NSString *)timeString withFormat:(NSString *)dateFormat
{
    return [[[self stringWithFormat:@"yyyy-MM-dd "] stringByAppendingString:timeString] dateFromFormat:[@"yyyy-MM-dd " stringByAppendingString:dateFormat]];
}

- (NSDate *)dateWithFormat:(NSString *)dateFormat
{
    return [[self stringWithFormat:dateFormat] dateFromFormat:dateFormat];
}

- (NSDate *)thisDay
{
    return [[self stringWithFormat:@"yyyy-MM-dd"] dateFromFormat:@"yyyy-MM-dd"];
}

+ (NSDate *)todayAddingTimeInterval:(NSTimeInterval)timeInterval
{
    return [[[NSDate date] thisDay] dateByAddingTimeInterval:timeInterval];
}

- (NSUInteger)birthdayAge {
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSUInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}

/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */
- (NSString *)smartDisplay {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:self toDate:now options:0];
    
    if ([self isThisYear]) { // 今年
        if ([self isYesterday]) { // 昨天
            fmt.dateFormat = [NSString stringWithFormat:@"%@ HH:mm", ATLocalizedString(@"Yesterday", @"昨天")];
            return [fmt stringFromDate:self];
        } else if ([self isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d%@", (int)cmps.hour, ATLocalizedString(@"hours ago", @"小时前")];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d%@", (int)cmps.minute, ATLocalizedString(@"minutes ago", @"分钟前")];
            } else {
                return ATLocalizedString(@"Just now", @"刚刚");
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:self];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:self];
    }
}
/**
 *  过去的时间（根据smartDisplay修改）
 */
- (NSString *)passTimeDisplay {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:self toDate:now options:0];
    
    if ([self isThisYear]) { // 今年
        if ([self isYesterday]) { // 昨天
            fmt.dateFormat = ATLocalizedString(@"Yesterday", @"昨天");
            return [fmt stringFromDate:self];
        } else if ([self isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d%@", (int)cmps.hour, ATLocalizedString(@"hours ago", @"小时前")];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d%@", (int)cmps.minute, ATLocalizedString(@"minutes ago", @"分钟前")];
            } else {
                return ATLocalizedString(@"Just now", @"刚刚");
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd";
            return [fmt stringFromDate:self];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:self];
    }
}
@end


@implementation NSString (NSDateString)

- (NSDate *)dateFromFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:dateFormat];
    
    return [dateFormatter dateFromString:self];
}

@end