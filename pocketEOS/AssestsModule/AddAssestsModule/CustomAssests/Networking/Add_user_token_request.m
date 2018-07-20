//
//  Add_user_token_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Add_user_token_request.h"

@implementation Add_user_token_request


-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/add_user_token", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    return @{
             @"assetName"  : VALIDATE_STRING(self.assetName),
             @"contractName"  : VALIDATE_NUMBER(self.contractName),
             @"accountName"  : VALIDATE_NUMBER(self.accountName)
             };
}


@end
