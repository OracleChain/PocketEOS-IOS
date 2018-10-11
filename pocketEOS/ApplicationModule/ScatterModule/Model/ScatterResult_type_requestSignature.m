//
//  ScatterResult_authenticate.m
//  PocketSocket
//
//  Created by oraclechain on 2018/9/17.
//  Copyright © 2018 Zwopple Limited. All rights reserved.
//

#import "ScatterResult_type_requestSignature.h"

@implementation ScatterResult_type_requestSignature

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"expiration" : @"transaction.expiration",
             @"ref_block_num" : @"transaction.ref_block_num",
             @"ref_block_prefix" : @"transaction.ref_block_prefix",
             @"chainId" : @"data.payload.network.chainId",
             @"actions" : @"transaction.actions",
             @"actor" : @"transaction.actions[0].authorization[0].actor",
             @"permission" : @"transaction.actions[0].authorization[0].permission"
             };
//    return @{
//              @"scatterResult_id" : @"data.id",
//             @"type" : @"data.type",
//              @"transaction" : @"data.payload.transaction",
//             @"expiration" : @"data.payload.transaction.expiration",
//             @"ref_block_num" : @"data.payload.transaction.ref_block_num",
//             @"ref_block_prefix" : @"data.payload.transaction.ref_block_prefix",
//             @"chainId" : @"data.payload.network.chainId",
//             @"actions" : @"data.payload.transaction.actions",
//             @"actor" : @"data.payload.transaction.actions[0].authorization[0].actor",
//             @"permission" : @"data.payload.transaction.actions[0].authorization[0].permission"
//             };
}

@end
