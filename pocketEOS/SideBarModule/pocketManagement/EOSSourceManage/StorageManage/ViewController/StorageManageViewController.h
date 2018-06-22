//
//  StorageManageViewController.h
//  pocketEOS
//
//  Created by 师巍巍 on 21/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"
#import "EOSResourceCellModel.h"
#import "AccountResult.h"

@interface StorageManageViewController : BaseViewController

@property(nonatomic , strong) EOSResourceResult *eosResourceResult;
@property (nonatomic , retain) UINavigationController *navigationController;
@property(nonatomic , copy) NSString *currentAccountName;
@property(nonatomic , strong) AccountResult *accountResult;

@end
