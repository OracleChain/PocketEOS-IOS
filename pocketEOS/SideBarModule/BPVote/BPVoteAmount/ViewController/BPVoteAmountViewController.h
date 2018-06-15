//
//  BPVoteAmountViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"
#import "Account.h"
#import "MyVoteInfoResult.h"

@interface BPVoteAmountViewController : BaseViewController

@property(nonatomic , strong) NSMutableArray *choosedBPDataArray;

@property(nonatomic , strong) Account *model;

@property(nonatomic , strong) MyVoteInfoResult *myVoteInfoResult;
@end
