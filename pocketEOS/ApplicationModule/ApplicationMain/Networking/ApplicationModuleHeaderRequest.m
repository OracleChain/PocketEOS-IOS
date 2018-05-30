//
//  ApplicationModuleHeaderRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/27.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "ApplicationModuleHeaderRequest.h"

@implementation ApplicationModuleHeaderRequest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/enterprise/intro", REQUEST_PERSONAL_BASEURL];
}

@end
