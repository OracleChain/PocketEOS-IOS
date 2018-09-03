//
//  TransferRecordsTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TransactionRecord.h"
#import "RedPacketDetailSingleAccount.h"



@interface TransferRecordsTableViewCell : BaseTableViewCell
@property(nonatomic , copy) NSString *currentAccountName;


/**
 转账记录cell
 */
@property(nonatomic, strong) TransactionRecord *model;


/**
 红包详情记录 cell
 */
@property(nonatomic , strong) RedPacketDetailSingleAccount *redPacketDetailSingleAccount;
@end
