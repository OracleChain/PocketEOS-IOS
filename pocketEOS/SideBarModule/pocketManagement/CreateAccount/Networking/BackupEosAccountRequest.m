//
//  BackupEosAccountRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BackupEosAccountRequest.h"

@implementation BackupEosAccountRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/user/add_new_eos", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    return @{
             @"uid" : VALIDATE_STRING(self.uid),
             @"eosAccountName" : VALIDATE_STRING(self.eosAccountName)
             
             };
}
@end

