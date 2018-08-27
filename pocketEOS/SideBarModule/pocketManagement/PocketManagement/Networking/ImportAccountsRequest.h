//
//  ImportAccountsRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface ImportAccountsRequest : BaseNetworkRequest

@property(nonatomic, copy) NSString *uid;

@property(nonatomic, strong) NSArray *accountList;

@end
