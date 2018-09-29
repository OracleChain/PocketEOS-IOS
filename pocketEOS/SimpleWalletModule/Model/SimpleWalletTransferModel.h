//
//  SimpleWalletTransferModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleWalletTransferModel : NSObject
@property(nonatomic , copy) NSString *protocol;
@property(nonatomic , copy) NSString *version;
@property(nonatomic , copy) NSString *dappName;
@property(nonatomic , copy) NSString *dappIcon;
@property(nonatomic , copy) NSString *action;
@property(nonatomic , copy) NSString *from;
@property(nonatomic , copy) NSString *to;
@property(nonatomic , copy) NSString *amount;
@property(nonatomic , copy) NSString *contract;
@property(nonatomic , copy) NSString *symbol;
@property(nonatomic , copy) NSString *precision;
@property(nonatomic , copy) NSString *dappData;
@property(nonatomic , copy) NSString *desc;
@property(nonatomic , strong) NSNumber *expired;
@property(nonatomic , copy) NSString *callback;

@end
