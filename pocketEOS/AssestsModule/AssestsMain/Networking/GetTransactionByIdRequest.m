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
    return [NSString stringWithFormat:@"%@/VX/GetTransactionById/%@", REQUEST_HISTORY_HTTP, self.transactionId];
    
}


@end
