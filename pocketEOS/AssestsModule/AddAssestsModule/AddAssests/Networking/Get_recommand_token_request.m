//
//  Get_recommand_token_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_recommand_token_request.h"

@implementation Get_recommand_token_request
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/get_asset_token", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    
    return @{
             @"accountName" : VALIDATE_STRING(self.accountName) ,
             @"offset" : VALIDATE_NUMBER(self.offset),
             @"size" : VALIDATE_NUMBER(self.size),
             @"ids" : VALIDATE_ARRAY(self.ids) 
             };
}
@end
