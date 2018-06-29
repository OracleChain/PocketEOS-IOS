//
//  AESCrypt.m
//  Gurpartap Singh
//
//  Created by Gurpartap Singh on 06/05/12. (Edited by afon on 13-8-5.)
//  Copyright (c) 2012 Gurpartap Singh
// 
// 	MIT License
// 
// 	Permission is hereby granted, free of charge, to any person obtaining
// 	a copy of this software and associated documentation files (the
// 	"Software"), to deal in the Software without restriction, including
// 	without limitation the rights to use, copy, modify, merge, publish,
// 	distribute, sublicense, and/or sell copies of the Software, and to
// 	permit persons to whom the Software is furnished to do so, subject to
// 	the following conditions:
// 
// 	The above copyright notice and this permission notice shall be
// 	included in all copies or substantial portions of the Software.
// 
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// 	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// 	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// 	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "AESCrypt.h"

#import "Base64.h"
#import "NSData+CommonCrypto.h"
#import "PBKDF2.h"
#import "NSObject+Extension.h"

const int SALT_LEN = 32;
const int ITERATIONS = 1000;
const int KEY_LENGTH = 32;

@implementation AESCrypt

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password {
    return [self encryptData:[message dataUsingEncoding:NSUTF8StringEncoding] password:password];
}

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password {
    if (base64EncodedString.length < SALT_LEN) {
        return nil;
    }
    NSData *decryptedData = [self decryptData:base64EncodedString password:password];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+ (NSString *)encryptData:(NSData *)data password:(NSString *)password {
    NSString *salt = [PBKDF2 rand_str:SALT_LEN];
//    NSString *salt = @"GNEbwYQ6wBDSp32bXIYnzRnpgQd2KYdI";
    NSData *derivedKey = [PBKDF2 pbkdf2:password salt:salt count:ITERATIONS kLen:KEY_LENGTH withAlgo:kSHA1];
    NSLog(@"%@", salt);
//    [NSObject out_Hex:derivedKey.bytes andLength:derivedKey.length];
    NSData *encryptedData = [data AES256EncryptedDataUsingKey:derivedKey error:nil];
//    [NSObject out_Int8_t:encryptedData.bytes andLength:encryptedData.length];
//    NSString *base64EncodedString = [encryptedData base64EncodedStringWithWrapWidth:[encryptedData length]];
//    NSString *mixedData = [NSString stringWithFormat:@"%@%@", salt, base64EncodedString];
    
   NSString *hexEncodedString =  [NSObject hexFromBytes:encryptedData.bytes andLength:encryptedData.length];
    NSString *mixedData = [NSString stringWithFormat:@"%@%@", salt,hexEncodedString];
    return mixedData;
}

+ (NSData *)decryptData:(NSString *)base64EncodedString password:(NSString *)password {
    NSString *salt = [base64EncodedString substringToIndex:SALT_LEN];
//    NSData *encryptedData = [NSData dataWithBase64EncodedString:[base64EncodedString substringFromIndex:SALT_LEN]];
    
    NSData *encryptedData = [NSObject convertHexStrToData:[base64EncodedString substringFromIndex:SALT_LEN]];
    NSData *derivedKey = [PBKDF2 pbkdf2:password salt:salt count:ITERATIONS kLen:KEY_LENGTH withAlgo:kSHA1];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:derivedKey error:nil];
    return decryptedData;
}

@end
