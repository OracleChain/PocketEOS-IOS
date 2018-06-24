//
//  NSString+DecimalsCalculation.h
//  YWDecimalsCalculation
//
//  Created by FishYu on 16/11/4.
//  Copyright © 2016年 codeFisher. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 // Rounding policies :
 // Original
 //    value 1.2  1.21  1.25  1.35  1.27
 // Plain    1.2  1.2   1.3   1.4   1.3
 // Down     1.2  1.2   1.2   1.3   1.2
 // Up       1.2  1.3   1.3   1.4   1.3
 // Bankers  1.2  1.2   1.2   1.4   1.3
 
 typedef NS_ENUM(NSUInteger, NSRoundingMode) {
 NSRoundPlain,   // 四舍五入
 NSRoundDown,    // 向下取舍
 NSRoundUp,      // 向上入
 NSRoundBankers  // 同四舍五入。但是当需要进位的数字是5时根据前一位的奇偶性，奇数向上取值、偶数向下取值
 };
 */

@interface NSString (DecimalsCalculation)

// 数字字符比较
/*
 @return NSComparisonResult
 NSOrderedAscending = -1L, NSOrderedSame,           NSOrderedDescending
 当前数小于numberString      当前数等于numberString      当前数大于numberString
 */
- (NSComparisonResult)yw_numberStringCompare:(NSString *)numberString;
// 加
/**
 加法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果,
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 被加数
 @return 返回结果
 */
- (NSString *)yw_stringByAdding:(NSString *)stringNumber;
- (NSString *)yw_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)yw_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;

// 减
/**
 减法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 减数
 @return 返回结果
 */
- (NSString *)yw_stringBySubtracting:(NSString *)stringNumber;
- (NSString *)yw_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)yw_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;

// 乘
/**
 乘法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 减数
 @return 返回结果
 */
- (NSString *)yw_stringByMultiplyingBy:(NSString *)stringNumber;
- (NSString *)yw_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)yw_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;

// 除
/**
 除法计算，默认保留两位小数，默认采用四舍五入的方式处理计算结果
 roundingModel决定四舍五入的方式，scale决定保留小数个数
 @param stringNumber 减数
 @return 返回结果
 */
- (NSString *)yw_stringByDividingBy:(NSString *)stringNumber;
- (NSString *)yw_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel;
- (NSString *)yw_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale;

@end

