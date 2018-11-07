//
//  Get_pocketeos_info_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_pocketeos_info_request.h"

@implementation Get_pocketeos_info_request

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/get_pocketeos_info", REQUEST_PERSONAL_BASEURL];
}

@end
