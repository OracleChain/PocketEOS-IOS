//
//  TransferRecordsTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TransactionRecord.h"

@interface TransferRecordsTableViewCell : BaseTableViewCell
@property(nonatomic , copy) NSString *currentAccountName;
@property(nonatomic, strong) TransactionRecord *model;
@end
