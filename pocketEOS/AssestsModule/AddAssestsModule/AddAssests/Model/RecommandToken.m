//
//  RecommandToken.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RecommandToken.h"

@implementation RecommandToken

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"recommandToken_ID" : @"tokenInfo.id",
             @"assetName" : @"tokenInfo.assetName",
             @"contractName" : @"tokenInfo.contractName",
             @"coinmarketId" : @"tokenInfo.coinmarketId",
             @"iconUrl" : @"tokenInfo.iconUrl",
             @"iconUrlHd" : @"tokenInfo.iconUrlHd",
             };
}

@end
