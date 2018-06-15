//
//  GetTransactionRecordsRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetTransactionRecordsRequest.h"

@implementation GetTransactionRecordsRequest
-(NSString *)requestUrlPath{
    return @"/get_transactions";
}

-(id)parameters{
    return @{
             @"account_name"  : VALIDATE_STRING(self.account_name),
             @"skip_seq"  : VALIDATE_NUMBER(self.skip_seq),
             @"num_seq"  : VALIDATE_NUMBER(self.num_seq)
             };
}
@end
