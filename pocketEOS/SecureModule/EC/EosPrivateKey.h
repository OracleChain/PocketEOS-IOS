//
//  EosPrivateKey.h
//  wif_test
//
//  Created by oraclechain on 2018/3/14.
//  Copyright © 2018年 宋赓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EosPrivateKey : NSObject
- (instancetype)initEosPrivateKey;
@property(nonatomic, strong) NSString *eosPrivateKey;

@property(nonatomic, strong) NSString *eosPublicKey;


@end
