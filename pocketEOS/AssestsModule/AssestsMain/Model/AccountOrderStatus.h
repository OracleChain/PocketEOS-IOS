//
//  AccountOrderStatus.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountOrderStatus : NSObject

@property(nonatomic , copy) NSString *accountName;


//statusOk = 1; statusWait = 2; statusDiscarded = 3; statusCreateByOthers = 4; orderNotExist=5;
@property(nonatomic , strong) NSNumber *createStatus;

@property(nonatomic , copy) NSString *message;

@end
