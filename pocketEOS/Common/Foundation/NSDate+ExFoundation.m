//
//  NSDate+NSDate_ExFoundation.m
//  Giivv
//
//  Created by Xiong,Zijun on 16/5/1.
//  Copyright © 2016  Youdar . All rights reserved.
//

#import "NSDate+ExFoundation.h"

@implementation NSDate (ExFoundation)
#pragma makr - date fransfer
+ (NSDate *)dateWithDouble:(double) timeSpan{
    return [NSDate dateWithTimeIntervalSince1970: timeSpan / 1000.0f];
}

#pragma mark - tommorrow date
+ (NSDate *)tommorrow{
    return  [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60];
}

#pragma mark - ISO 8601格式转NSDate
+ (NSDate *)dateFromISO8601String:(NSString *)string {
    if (IsNilOrNull(string)){
        return nil;
    }
    
    struct tm tm;
    time_t t;
    
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    
    return [NSDate dateWithTimeIntervalSince1970:t]; // 零时区
        //    return [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];//东八区
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
//    return [dateFormatter dateFromString: string];
}

#pragma mark - ISO 8601格式转NSDate
- (NSString *)formatterToISO8601{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    
    NSString *formattedDateString = [dateFormatter stringFromDate: self];
    return formattedDateString;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //需要转换的字符串
    NSString *dateString = string;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    if ([string containsString:@"."]) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

#pragma mark - 周四 02/14 10:00 PM
- (NSString *)formatterToWeekDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MM/dd HH:mma";
    
    NSString *formattedDateString = [dateFormatter stringFromDate: self];
    return formattedDateString;
}

#pragma mark - date formate
- (NSString *)stringFormate:(NSString *) formation{
    if(IsNilOrNull(formation)){
        return nil;
    }
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat: formation];
    return [dateFormater stringFromDate: self];
}

#pragma mark - timeStamp from date
- (NSNumber *)timeStamp{
//    NSLog(@"%@", [self stringFormate: @"yyyy-MM-dd"]);
    NSString *dateString = [self stringFormate: @"MM/dd/yyyy"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *utcDate = [dateFormatter dateFromString: dateString];
    return @((long long)[utcDate timeIntervalSince1970] * 1000);
}

#pragma mark - 当前时间大于等于指定时间
- (BOOL)largeAndEqualDate:(NSDate *)date{
    
    if(IsNilOrNull(date)){
        return YES;
    }
    
    NSComparisonResult result = [self compare: date];
    switch (result){
            
        case NSOrderedAscending:
            //date2比date1大
            return NO;
        case NSOrderedDescending:
            //date2比date1小
            return YES;
        case NSOrderedSame:
            //date2=date1
            return YES;
    }
}

#pragma mark - 当前时间小于等于指定时间
- (BOOL)lowerAndEqualDate:(NSDate *)date{
    
    if(IsNilOrNull(date)){
        return YES;
    }
    
    NSComparisonResult result = [self compare: date];
    switch (result){
            
        case NSOrderedAscending:
            //date2比date1大
            return YES;
        case NSOrderedDescending:
            //date2比date1小
            return NO;
        case NSOrderedSame:
            //date2=date1
            return YES;
    }
}



+ (int)getTimeStampUTCWithTimeString:(NSString *)timeString{
    
    NSDate *anyDate = [NSDate dateFromString:timeString];//format :@"2018-01-01T08:00:00"
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] ;
    
    
    int a = [destinationDateNow timeIntervalSince1970];
    NSLog(@"%@\n=====%@\n ====%d\n", anyDate, destinationDateNow, a);
    return a;
}

+(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *aDate = [dtFormat dateFromString:strDate];
    
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dtFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dtFormat stringFromDate:aDate];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}


@end
