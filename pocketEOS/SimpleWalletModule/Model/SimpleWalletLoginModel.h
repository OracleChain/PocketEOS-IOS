//
//  SimpleWalletLoginModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/28.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleWalletLoginModel : NSObject
@property(nonatomic , copy) NSString *protocol;
@property(nonatomic , copy) NSString *version;
@property(nonatomic , copy) NSString *dappName;
@property(nonatomic , copy) NSString *dappIcon;
@property(nonatomic , copy) NSString *action;
@property(nonatomic , copy) NSString *uuID;
@property(nonatomic , copy) NSString *loginUrl;
@property(nonatomic , strong) NSNumber *expired;
@property(nonatomic , copy) NSString *loginMemo;

@end
