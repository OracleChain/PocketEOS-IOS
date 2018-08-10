//
//  CheckWhetherHasFreeQuotaResuest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CheckWhetherHasFreeQuotaResuest.h"

@implementation CheckWhetherHasFreeQuotaResuest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/is_open_timeLimitRegister", REQUEST_PERSONAL_BASEURL];
}

@end
