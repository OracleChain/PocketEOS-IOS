//
//  TransferDetailsViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"
#import "TransactionRecord.h"

@interface TransferDetailsViewController : BaseViewController

@property(nonatomic , strong) TransactionRecord *model;
@end
