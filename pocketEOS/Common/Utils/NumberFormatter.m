//
//  NumberFormatter.m
//  pocketEOS
//
//  Created by oraclechain on 2018/3/22.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "NumberFormatter.h"

@implementation NumberFormatter
+ (NSString *)displayStringFromNumber:(NSNumber *)number{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.decimalSeparator = @".";// 小数点样式
    numberFormatter.maximumFractionDigits = 4;// 小数位最多位数
    numberFormatter.groupingSize = 3;// 数字分割的尺寸
    
    NSString *outStr = [numberFormatter stringFromNumber:VALIDATE_NUMBER(number)];
    return outStr;
}


@end
