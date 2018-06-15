//
//  BPVoteService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetMyVoteInfoRequest.h"

@interface BPVoteService : BaseService
@property(nonatomic , strong) GetMyVoteInfoRequest *getMyVoteInfoRequest;


@end
