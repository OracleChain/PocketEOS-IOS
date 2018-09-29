//
//  GetTransactionByIdRequest.m
//  pocketEOS
//
//  Created by oraclechain on 2018/9/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "GetTransactionByIdRequest.h"

@implementation GetTransactionByIdRequest

-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"http://history.pocketeos.top/VX/GetTransactionById/%@",  self.transactionId];
//    return [NSString stringWithFormat:@"http://history.pocketeos.top/VX/GetTransactionById/ea1711ed992d6a96cebfe52fd5b39805137cbdba056e74fcc66765675e6dbe3d"];
}


@end
