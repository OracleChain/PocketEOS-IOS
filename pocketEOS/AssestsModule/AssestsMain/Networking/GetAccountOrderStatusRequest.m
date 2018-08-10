//
//  GetAccountOrderStatusRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetAccountOrderStatusRequest.h"

@implementation GetAccountOrderStatusRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/getAccountOrder/%@/%@", REQUEST_PAY_CREATEACCOUNT_BASEURL, self.accountName, self.uid];
}


@end
