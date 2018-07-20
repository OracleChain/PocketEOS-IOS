//
//  Get_user_custom_token_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_user_custom_token_request.h"

@implementation Get_user_custom_token_request

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/get_user_token?accountName=%@", REQUEST_PERSONAL_BASEURL, self.accountName];
}
@end
