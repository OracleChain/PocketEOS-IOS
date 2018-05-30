//
//  EOS_Key_Encode.h
//  wif_test
//
//  Created by oraclechain on 2018/3/14.
//  Copyright © 2018年 宋赓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOS_Key_Encode : NSObject
/**
 validate wif format
 */
+ (BOOL)validateWif:(NSString *)wif;

/**
 getRandomBytesDataWithWif
 */
+ (NSData*)getRandomBytesDataWithWif:(NSString *)wif;

/**
 wif_with_random_bytes_data
 @param random_bytesData random_bytesData
 @return wif
 */
+ (NSString *)wif_with_random_bytes_data:(NSData *)random_bytesData;

/**
 eos_publicKey_with_wif
 
 @param wif wif
 @return eos_publicKey
 */
+ (NSString *)eos_publicKey_with_wif:(NSString *)wif;



/**
 encode uecc_publicKey --> eos_PublicKey
 @param uecc_publicKey_bytes_data uecc_publicKey_bytes_data
 @return eos_PublicKey
 */
+ (NSString *)encode_eos_PublicKey_with_uecc_publicKey_bytes_data:(NSData *)uecc_publicKey_bytes_data;


/**
 decode eos_PublicKey --> uecc_publicKey_bytes_data
 @param eos_publicKey uecc_publicKey_bytes_data
 @return uecc_publicKey_bytes_data
 */
+ (NSData *)decode_eos_publicKey:(NSString *)eos_publicKey;




@end

