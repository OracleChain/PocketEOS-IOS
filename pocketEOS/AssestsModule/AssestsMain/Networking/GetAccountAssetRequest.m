//
//  GetAccountAssetRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetAccountAssetRequest.h"

@implementation GetAccountAssetRequest

-(NSString *)requestUrlPath{
    return @"/get_account_asset";
}

-(id)parameters{
    return @{@"name" : VALIDATE_STRING(self.name) };
}
@end
