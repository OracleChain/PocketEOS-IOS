//
//  Get_category_config_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_category_config_request.h"

@implementation Get_category_config_request

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/category_config", REQUEST_PERSONAL_BASEURL];
}


@end
