//
//  GetCreateAccountResourceRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetCreateAccountResourceRequest.h"

@implementation GetCreateAccountResourceRequest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/getAccountCreateResource", REQUEST_PAY_CREATEACCOUNT_BASEURL];
}

@end
