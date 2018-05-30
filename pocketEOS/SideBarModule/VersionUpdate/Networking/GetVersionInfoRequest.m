//
//  GetVersionInfoRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "GetVersionInfoRequest.h"

@implementation GetVersionInfoRequest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/get_last_info", REQUEST_PERSONAL_BASEURL];
}
@end
