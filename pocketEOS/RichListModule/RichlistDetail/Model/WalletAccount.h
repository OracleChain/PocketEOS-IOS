//
//  WalletAccount.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletAccount : NSObject
@property(nonatomic, strong) NSString *eosAccountName;

@property(nonatomic, strong) NSNumber *isMainAccount;

@end
