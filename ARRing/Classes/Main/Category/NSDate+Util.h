//
//  NSDate+Util.h
//  AT
//
//  Created by xiao6 on 14-10-13.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDate (NSDateString)
/**
 *  时间转换为字符串
 *
 *  @param dateFormat @“yyyy-MM-dd EEEE HH:mm:ss zzz” ==> @"2114-10-13 星期一 20:13:17 +8:00"
 *
 *  @return 字符串
 */
- (NSString *)stringWithFormat:(NSString *)dateFormat;
/**
 *  设置时间 @“16:30”
 *
 *  @param timeString @“16:30”
 *  @param dateFormat @“HH:mm”
 *
 *  @return 时间
 */
- (NSDate *)dateSetTime:(NSString *)timeString withFormat:(NSString *)dateFormat;

- (NSDate *)thisDay;
- (NSDate *)dateWithFormat:(NSString *)dateFormat;
+ (NSDate *)todayAddingTimeInterval:(NSTimeInterval)timeInterval;
- (NSUInteger)birthdayAge;
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;
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
- (NSString *)smartDisplay;
/**
 *  过去的时间（根据smartDisplay修改）
 */
- (NSString *)passTimeDisplay;
@end

@interface NSString (NSDateString)
/**
 *  字符串转换为时间
 *
 *  @param dateFormat @“yyyy-MM-dd EEEE HH:mm:ss zzz” ==> @"2114-10-13 星期一 20:13:17 +8:00"
 *
 *  @return 时间
 */
- (NSDate *)dateFromFormat:(NSString *)dateFormat;

@end
