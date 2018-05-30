//
//  GetWalletAccountsRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetWalletAccountsRequest.h"

@implementation GetWalletAccountsRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/user/getEosAccount", REQUEST_PERSONAL_BASEURL ];
}
-(id)parameters{
    return @{@"uid" : VALIDATE_STRING(self.uid)};
}
@end
