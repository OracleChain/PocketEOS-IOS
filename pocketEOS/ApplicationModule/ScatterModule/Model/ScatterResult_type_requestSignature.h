//
//  ScatterResult_authenticate.h
//  PocketSocket
//
//  Created by oraclechain on 2018/9/17.
//  Copyright © 2018 Zwopple Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScatterResult_type_requestSignature : NSObject

@property(nonatomic , copy) NSString *scatterResult_id;

@property(nonatomic , copy) NSString *expiration;

@property(nonatomic , copy) NSString *ref_block_num;

@property(nonatomic , copy) NSString *ref_block_prefix;

@property(nonatomic , copy) NSString *chainId;

@property(nonatomic , copy) NSString *actor;

@property(nonatomic , copy) NSString *permission;

@property(nonatomic , strong) NSArray *actions;

@property(nonatomic , strong) NSMutableDictionary *transaction;

@end
