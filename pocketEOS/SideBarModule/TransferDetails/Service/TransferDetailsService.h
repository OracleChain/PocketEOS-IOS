//
//  TransferDetailsService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "TransactionRecord.h"

@interface TransferDetailsService : BaseService


@property(nonatomic , strong) NSMutableDictionary *dataSourceDictionary;

@property(nonatomic, strong) TransactionRecord *model;



@end
