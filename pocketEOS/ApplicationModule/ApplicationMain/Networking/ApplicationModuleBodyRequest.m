//
//  ApplicationModuleBodyRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/27.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "ApplicationModuleBodyRequest.h"

@implementation ApplicationModuleBodyRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/enterprise/intro_all_app", REQUEST_PERSONAL_BASEURL];
}
@end
