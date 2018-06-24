//
//  NSString+DecimalsCalculation.m
//  YWDecimalsCalculation
//
//  Created by FishYu on 16/11/4.
//  Copyright © 2016年 codeFisher. All rights reserved.
//

#import "NSString+DecimalsCalculation.h"

// CalculationType
typedef NS_ENUM(NSInteger,CalculationType){
    CalculationAdding,
    CalculationSubtracting,
    CalculationMultiplying,
    CalculationDividing,
};

@implementation NSString (DecimalsCalculation)
// Compare
- (NSComparisonResult)yw_numberStringCompare:(NSString *)numberString {
    NSDecimalNumber *selfNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *calcuationNumber = [NSDecimalNumber decimalNumberWithString:numberString];
    return [selfNumber compare:calcuationNumber];
}
// Adding
- (NSString *)yw_stringByAdding:(NSString *)stringNumber {
    return [self yw_stringByAdding:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)yw_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self yw_stringByAdding:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)yw_stringByAdding:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:CalculationAdding by:stringNumber roundingMode:roundingModel scale:scale];
}

// Substracting
- (NSString *)yw_stringBySubtracting:(NSString *)stringNumber {
    return [self  yw_stringBySubtracting:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)yw_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self  yw_stringBySubtracting:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)yw_stringBySubtracting:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:CalculationSubtracting by:stringNumber roundingMode:roundingModel scale:scale];
}

// Multiplying
- (NSString *)yw_stringByMultiplyingBy:(NSString *)stringNumber {
    return [self yw_stringByMultiplyingBy:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)yw_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self yw_stringByMultiplyingBy:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)yw_stringByMultiplyingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:CalculationMultiplying by:stringNumber roundingMode:roundingModel scale:scale];
}

// Dividing
- (NSString *)yw_stringByDividingBy:(NSString *)stringNumber {
    return [self yw_stringByDividingBy:stringNumber withRoundingMode:NSRoundPlain scale:2];
}
- (NSString *)yw_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel {
    return [self yw_stringByDividingBy:stringNumber withRoundingMode:roundingModel scale:2];
}
- (NSString *)yw_stringByDividingBy:(NSString *)stringNumber withRoundingMode:(NSRoundingMode)roundingModel scale:(NSInteger)scale {
    return [self _stringByCalculationType:CalculationDividing by:stringNumber roundingMode:roundingModel scale:scale];
}


- (NSString *)_stringByCalculationType:(CalculationType)type by:(NSString *)stringNumber roundingMode:(NSRoundingMode)roundingModel scale:(NSUInteger)scale{
    
    NSDecimalNumber *selfNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *calcuationNumber = [NSDecimalNumber decimalNumberWithString:stringNumber];
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:roundingModel scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *result = nil;
    switch (type) {
        case CalculationAdding:
            result = [selfNumber decimalNumberByAdding:calcuationNumber withBehavior:handler];
            break;
        case CalculationSubtracting:
            result =  [selfNumber decimalNumberBySubtracting:calcuationNumber withBehavior:handler];
            break;
        case CalculationMultiplying:
            result = [selfNumber decimalNumberByMultiplyingBy:calcuationNumber withBehavior:handler];
            break;
        case CalculationDividing:
            result =[selfNumber decimalNumberByDividingBy:calcuationNumber withBehavior:handler];
            break;
    }
    
    //  使用自定义formatter
    NSNumberFormatter *numberFormatter = [self _numberFormatterWithScale:scale];
    return [numberFormatter stringFromNumber:result];
}

- (NSNumberFormatter *)_numberFormatterWithScale:(NSInteger)scale{
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.minimumIntegerDigits = 1;
        numberFormatter.numberStyle = kCFNumberFormatterNoStyle;
    });
    numberFormatter.alwaysShowsDecimalSeparator = !(scale == 0);
    numberFormatter.minimumFractionDigits = scale;
    return numberFormatter;
}

@end

