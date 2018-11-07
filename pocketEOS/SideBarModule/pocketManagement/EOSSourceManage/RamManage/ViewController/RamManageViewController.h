//
//  RamManageViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountResult.h"
#import "EOSResourceResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface RamManageViewController : BaseViewController
@property (nonatomic , retain) UINavigationController *navigationController;

@property(nonatomic , strong) AccountResult *accountResult;

@property(nonatomic , strong) EOSResourceResult *eosResourceResult;
@end

NS_ASSUME_NONNULL_END
