//
//  GetBPCandidateListRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface GetBPCandidateListRequest : BaseNetworkRequest
@property(nonatomic, strong) NSNumber *pageNum;
@property(nonatomic, strong) NSNumber *pageSize;
@property(nonatomic , copy) NSString *accountName;
@end
