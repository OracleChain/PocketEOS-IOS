//
//  GetTransactionByIdRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetTransactionByIdRequest : BaseNetworkRequest


@property(nonatomic , copy) NSString *transactionId;

@end
