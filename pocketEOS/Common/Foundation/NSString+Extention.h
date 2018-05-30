//
//  NSString+Extention.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/30.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extention)

/**
 *  随机生成一个文件名
 *
 *  @param externName 文件的扩展名称
 *
 *  @return 生成之后的文件名
 */
- (NSString *)randomFileName:(NSString *)externName;






/**
 //获取某个字符串或者汉字的首字母
 */
+ (NSString *)firstCharactorWithString:(NSString *)string;


//金额千分位显示，保留小数点后两位
- (NSString *)amountFormat;


/**
 随机字符串 - 生成指定长度的字符串

 @param len <#len description#>
 @return <#return value description#>
 */
+(NSString *)randomStringWithLength:(NSInteger)len ;

+(NSString *)randomNumberStringWithLength:(NSInteger)len ;

/**
 转义jsonString
 
 @param aString  jsonStr
 @return 转义后的 jsonStr
 */
+(NSString *)escapeCharacterJSONString:(NSString *)aString;

//NSFileManager计算文件/文件夹大小
- (NSString *)fileSize;
@end
