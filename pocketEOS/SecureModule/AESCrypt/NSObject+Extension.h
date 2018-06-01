//
//  NSString+Extension.h
//  啊啊啊啊啊啊
//
//  Created by 师巍巍 on 04/03/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
- (long)string_to_long:(NSString *)str;

- (NSString *)stringFromHexString:(NSString *)hexString ;

/**
 随机数字字符串 - 生成指定长度的数字字符串
 @param len 指定长度
 @return 随机数字字符串
 */
-(NSString *)randomStringWithLength:(NSInteger)len ;

- (void)out_char:(unsigned char * )base andLength:(int)length;

- (void)out_Hex:(unsigned char * )base andLength:(int)length;

+ (void)out_Int8_t:( char * )base andLength:(int)length;

// 将 bytes 转为十六进制
- (NSString *)hexFromBytes:(unsigned char *)Hex andLength:(int)length;


+ (NSData *)convertHexStrToData:(NSString *)str;

+ (void)logoutByteWithNSData:(NSData *)buf andLength:(int)length;

/**
 compare char
 sizeof(charA) must equal to sizeof(charB)!
 @param charA charA
 @param charB charB
 @return result
 */
+ (NSInteger)compare_charWithCharA:(unsigned char *)charA andCharB:(unsigned char *)charB;
@end
