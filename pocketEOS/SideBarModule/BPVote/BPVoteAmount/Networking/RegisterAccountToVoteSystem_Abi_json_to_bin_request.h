//
//  RegisterAccountToVoteSystem_Abi_json_to_bin_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/11.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"


@interface RegisterAccountToVoteSystem_Abi_json_to_bin_request : BaseHttpsNetworkRequest
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *proxy;
@property(nonatomic, copy) NSString *isproxy;
@end
