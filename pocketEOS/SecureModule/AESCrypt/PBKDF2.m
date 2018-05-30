//
//  PBKDF2.m
//  pbkdf2
//
//  Created by afon on 13-8-3.
//  Copyright (c) 2013年 afon. All rights reserved.
//

#import "PBKDF2.h"
#import "Base64.h"

NSString* const kSHA1 = @"sh2a1";
//NSString* const kSHA256 = @"sh2a8";
//NSString* const kSHA512 = @"sh2a9";
const int DEFAULT_SALT_LENGTH = 20;
static NSString* delimiter = @"$";

@implementation PBKDF2

+ (NSData *)pbkdf2:(NSString *)password salt:(NSString *) s count:(int) c kLen:(int) l withAlgo:(NSString *)algo
{
    unsigned char key[l];
    CCKeyDerivationPBKDF(kCCPBKDF2, [password UTF8String], [password length], (const unsigned char *)[s UTF8String], [s length], [self getAlgoType:algo], c, key, l);
    return [NSData dataWithBytes:key length:l];
}

+ (NSData *)pbkdf2:(NSString *)password salt:(NSString *) s count:(int) c kLen:(int) l
{
    return [self pbkdf2:password salt:s count:c kLen:l withAlgo:kSHA1];
}

+ (NSString *)pass_hash:(NSString *) password length:(int) l count:(int) c saltLength:(int)sl withAlgo:(NSString *)algo
{
    NSString *s = [self rand_str:sl];
    NSData *hash_data = [self pbkdf2:password salt:s count:c kLen:l withAlgo:algo];
    return [NSString stringWithFormat:@"%@%@%02d%@%02d%@%@%@", algo, delimiter, c/1000, delimiter, l, delimiter, s, [hash_data base64EncodedString]];
}

+ (NSString *)pass_hash:(NSString *) password length:(int) l count:(int) c saltLength:(int)sl;
{
    return [self pass_hash:password length:l count:c saltLength:sl withAlgo:kSHA1];
}

+ (NSString *)pass_hash:(NSString *) password length:(int) l count:(int) c withAlgo:(NSString *)algo;
{
    return [self pass_hash:password length:l count:c saltLength:DEFAULT_SALT_LENGTH withAlgo:algo];
}

+ (NSString *)pass_hash:(NSString *) password length:(int) l count:(int) c
{
    return [self pass_hash:password length:l count:c saltLength:DEFAULT_SALT_LENGTH];
}

+ (NSString *)pass_hash:(NSString *) password length:(int) l
{
    return [self pass_hash:password length:l count:10000];
}

+ (NSString *)pass_hash:(NSString *) password
{
    return [self pass_hash:password length:32 count:10000];
}

+ (BOOL)pass_verify:(NSString *) password hash:(NSString *) h
{
    NSArray *p = [h componentsSeparatedByString:delimiter];
    NSString *salt_hash = [p objectAtIndex:3];
    unsigned long salt_len = [salt_hash length] - (unsigned long)ceil([[p objectAtIndex:2] doubleValue]/3) * 4;
    NSString *encoded_hash = [[self pbkdf2:password salt:[salt_hash substringToIndex: salt_len] count:[[p objectAtIndex:1] intValue]*1000 kLen:[[p objectAtIndex:2] intValue] withAlgo:[p objectAtIndex:0]] base64EncodedString];
    if ([encoded_hash isEqualToString:[salt_hash substringFromIndex:salt_len]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)rand_str:(int) l
{
    char pool[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    char data[l];
    for (int x=0;x<l;data[x++] = (char)(pool[arc4random_uniform(62)]));
    return [[NSString alloc] initWithBytes:data length:l encoding:NSUTF8StringEncoding];
}

+ (CCPBKDFAlgorithm)getAlgoType:(NSString *)str
{
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCCPRFHmacAlgSHA1], kSHA1, nil];
    return [[map objectForKey:str] intValue];
}

@end
