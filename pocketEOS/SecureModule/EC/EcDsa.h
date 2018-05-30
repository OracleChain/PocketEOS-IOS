//
//  EcDsa.h
//  啊啊啊啊啊啊
//
//  Created by oraclechain on 2018/3/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKBigInteger.h"

@interface SigChecker : NSObject
@property(nonatomic, strong) JKBigInteger *e;
@property(nonatomic, strong) JKBigInteger *privKey;
@property(nonatomic, strong) JKBigInteger *r;
@property(nonatomic, strong) JKBigInteger *s;
@end

@interface EcDsa : NSObject

@end
