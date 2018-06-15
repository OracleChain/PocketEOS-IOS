//
//  GetMyVoteInfoRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseHttpsNetworkRequest.h"

@interface GetMyVoteInfoRequest : BaseNetworkRequest
@property(nonatomic , copy) NSString *accountNameStr;
@end
