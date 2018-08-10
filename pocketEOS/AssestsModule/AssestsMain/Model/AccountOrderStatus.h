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

@property(nonatomic , strong) NSNumber *createStatus;

@property(nonatomic , copy) NSString *message;

@end
