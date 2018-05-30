//
//  NSData+Hash.m
//  啊啊啊啊啊啊
//
//  Created by oraclechain on 2018/3/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "NSData+Hash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@implementation NSData (Hash)
-(NSString *) sha256{
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(self.bytes, (CC_LONG)self.length, digest);
    
    NSMutableString* outputSha256_Digest = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++){
        [outputSha256_Digest appendFormat:@"%02x", digest[i]];
    }
    return outputSha256_Digest;
}

- (NSString *)hexadecimalString{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    
    return [NSString stringWithString:hexString];
}
@end
