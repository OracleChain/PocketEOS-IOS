//
//  EosPrivateKey.m
//  wif_test
//
//  Created by oraclechain on 2018/3/14.
//  Copyright © 2018年 宋赓. All rights reserved.
//

#import "EosPrivateKey.h"
#import "NSObject+Extension.h"
#include "sha2.h"
#include "uECC.h"
#include "libbase58.h"
#include "rmd160.h"

@interface EosPrivateKey()

@end


@implementation EosPrivateKey

- (instancetype)initEosPrivateKey
{
    self = [super init];
    if (self) {
        unsigned char str[32+1];
        for (int i = 0; i < 32; i += 2)
        {
            sprintf(&str[i], "%02X", arc4random() % 255);
        }
        
        //将私钥编码成wif格式
        unsigned char result[37];
        result[0] = 0x80;
        unsigned char degist[32];
        int len;
        char base[100];
        memcpy(result + 1 , str, 32);
        sha256_Raw(result, 33, degist);
        sha256_Raw(degist, 32, degist);
        memcpy(result+33, degist, 4);
        b58enc(base, &len, result,37);
        self.eosPrivateKey = [NSString stringWithUTF8String:base];
        
        uint8_t pub[64];
        uint8_t cpub[33];
        char *hash;
        // 生成公钥
        uECC_compute_public_key(str,pub);
        //
        //        printf("uECC_compute_public_key:\n");
        //        [NSObject out_Hex:pub andLength:64];
        
        //编码公钥
        uECC_compress(pub,cpub);
        hash = RMD(cpub, 33);
        memcpy(result, cpub, 33);
        memcpy(result+33, hash, 4);
        b58enc(base, &len, result,37);
        self.eosPublicKey = [NSString stringWithFormat:@"EOS%@", [NSString stringWithUTF8String:base]];
    }
    return self;
}

@end
