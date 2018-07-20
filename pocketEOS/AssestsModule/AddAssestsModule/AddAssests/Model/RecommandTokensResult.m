//
//  RecommandTokensResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RecommandTokensResult.h"

@implementation RecommandTokensResult
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"assetCategoryList" : @"RecommandToken",
             @"followAssetIds" : @"NSString"
              };
}
@end
