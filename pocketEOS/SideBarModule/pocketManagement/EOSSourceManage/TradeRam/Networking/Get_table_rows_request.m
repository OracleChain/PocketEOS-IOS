//
//  Get_table_rows_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_table_rows_request.h"

@implementation Get_table_rows_request

-(NSString *)requestUrlPath{
    return @"/get_table_rows";
}

-(id)parameters{
    return @{@"json":[NSNumber numberWithBool:YES],@"code":@"eosio",@"scope":@"eosio",@"table":@"rammarket",@"table_key":@"",@"lower_bound":@"",@"upper_bound":@"",@"limit":@10};
}

@end
