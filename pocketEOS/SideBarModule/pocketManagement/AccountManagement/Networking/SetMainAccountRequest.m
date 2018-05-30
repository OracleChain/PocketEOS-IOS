//
//  SetMainAccountRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "SetMainAccountRequest.h"

@implementation SetMainAccountRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/user/toggleEosMain", REQUEST_PERSONAL_BASEURL];;
}
-(id)parameters{
    return @{@"uid" : VALIDATE_STRING(self.uid),
             @"eosAccountName" : VALIDATE_STRING(self.eosAccountName)};
}
@end
