//
//  Sha256.h
//  啊啊啊啊啊啊
//
//  Created by oraclechain on 2018/3/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sha256 : NSObject
@property(nonatomic, strong) NSData *mHashBytesData;
// sha256result with hex encoding 
@property(nonatomic, strong) NSString *sha256;
- (instancetype)initWithData:(NSData *)bytesData;

@end
