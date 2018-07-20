//
//  Delete_user_custom_token_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Delete_user_custom_token_request.h"

@implementation Delete_user_custom_token_request
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/delete_user_token", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    return @{
             @"accountName"  : VALIDATE_STRING(self.accountName),
             @"id"  : VALIDATE_NUMBER(self.recommandToken_ID)
             };
}

@end
