//
//  NSDate+NSDate_ExFoundation.h
//  Giivv
//
//  Created by Xiong,Zijun on 16/5/1.
//  Copyright © 2016  Youdar . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ExFoundation)
/**
 *  date fransfer
 *
 *  @param timeSpan value of timespan
 *
 *  @return tranfer date
 */
+ (NSDate *)dateWithDouble:(double) timeSpan;

/**
 *  tommorrow date
 *
 *  @return NSdate
 */
+ (NSDate *)tommorrow;

/**
 *  ISO8601格式的时间日期字符串转换成NSDate
 *
 *  @param string 将要解析的字符串
 *
 *  @return string
 */
+ (NSDate *)dateFromISO8601String:(NSString *)string;


/**
 NSString转NSDate
 */
+ (NSDate *)dateFromString:(NSString *)string;

/**
 *  NSDate转换成ISO8601格式的字符串
 *
 *  @return 格式化之后的字符串
 */
- (NSString *)formatterToISO8601;

#pragma mark - 周四 02/14 10:00 PM
- (NSString *)formatterToWeekDay;

/**
 *  date formate
 *
 *  @param formation formate string
 *
 *  @return string after formate
 */
- (NSString *)stringFormate:(NSString *) formation;

/**
 *  timeStamp from date
 *
 *  @return timeStamp
 */
- (NSNumber *)timeStamp;

- (BOOL)largeAndEqualDate:(NSDate *)date;

- (BOOL)lowerAndEqualDate:(NSDate *)date;


// 获取给定的时间 的 utc 时间的时间戳
+ (int)getTimeStampUTCWithTimeString:(NSString *)timeString;


@end
