//
//  CompleteBPVoteRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/13.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface CompleteBPVoteRequest : BaseNetworkRequest

@property(nonatomic , copy) NSString *task_ID;
@property(nonatomic , copy) NSString *uid;

@end
