//
//  NSString+Extention.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/30.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)


#pragma mark - 随机生成一个文件名
- (NSString *)randomFileName:(NSString *)externName{
    return [NSString stringWithFormat: @"%@%@.%@",self, [[NSDate date] stringFormate: @"yyyyMMddHHmmssSSS"], externName];
}

+ (NSString *)firstCharactorWithString:(NSString *)string{
    if (string.length > 0) {
        
        NSMutableString *str = [NSMutableString stringWithString:string];
        CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
        NSString *pinYin = [str capitalizedString];
        NSString *finalStr = [pinYin substringToIndex:1];
        return finalStr;
    }else{
        return @"";
    }
    
}

//金额千分位显示，保留小数点后两位
- (NSString *)amountFormat{
    
    if(!self || [self floatValue] == 0){
        return @"0.00";
    }else{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@",###.00;"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
    }
    return @"";
    //[numberFormatter setPositiveFormat:@",###.00”];//输出：677，789.98
    // [numberFormatter setPositiveFormat:@".00;”]//输出：677789.98
    //  [numberFormatter setPositiveFormat:@“0%;”]//输出：67778998%
    //  [numberFormatter setPositiveFormat:@“0.00%;”]//输出：67778998.00%
}
+(NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}

+(NSString *)randomNumberStringWithLength:(NSInteger)len{
    NSString *letters = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}


/**
 转义jsonString

 @param aString  jsonStr
 @return 转义后的 jsonStr
 */
+(NSString *)escapeCharacterJSONString:(NSString *)aString{
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

- (NSString *)fileSize{
    // 总大小
    unsigned long long size = 0;
    
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 是否为文件夹
    BOOL isDirectory = NO;
    
    // 路径是否存在
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    if (!exists) return @"暂无缓存,您无需清理~";
    
    if (isDirectory) { // 文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    } else { // 文件
        size = [mgr attributesOfItemAtPath:self error:nil].fileSize;
    }
    const unsigned int bytes = 1024*1024 ;   //字节数，如果想获取KB就1024，MB就1024*1024
    NSString *string = [NSString stringWithFormat:@"%.2fMB",(1.0 *size/bytes)];
    NSLog(@"CacheSize:%@",string);
    return string;
}
@end
