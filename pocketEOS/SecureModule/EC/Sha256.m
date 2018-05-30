//
//  Sha256.m
//  啊啊啊啊啊啊
//
//  Created by oraclechain on 2018/3/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "Sha256.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation Sha256

- (instancetype)initWithData:(NSData *)bytesData
{
    self = [super init];
    if (self) {
        
        uint8_t digest[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(bytesData.bytes, (CC_LONG)bytesData.length, digest);
        self.mHashBytesData = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
        
        NSMutableString* outputSha256_Digest = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++){
            [outputSha256_Digest appendFormat:@"%02x", digest[i]];
        }
        self.sha256 = outputSha256_Digest;
    }
    return self;
}




@end
