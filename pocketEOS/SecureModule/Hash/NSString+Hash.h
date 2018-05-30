//
//  NSString+Secure.h
//  asda sdas
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)
-(NSString *) sha1;
-(NSString *) sha224;
-(NSString *) sha256;
-(NSString *) sha384;
-(NSString *) sha512;
+ (BOOL)validateWalletPasswordWithSha256:(NSString *)sha256 password:(NSString *)password;
@end

