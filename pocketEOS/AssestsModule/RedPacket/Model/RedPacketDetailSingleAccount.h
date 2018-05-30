//
//  RedPacketDetailSingleAccount.h
//  pocketEOS
//
//  Created by oraclechain on 20/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RedPacketDetailSingleAccount : NSObject
@property(nonatomic , copy) NSString *type;
@property(nonatomic , copy) NSString *amount;
@property(nonatomic , copy) NSString *account;
@property(nonatomic , copy) NSString *createTime;
@end
