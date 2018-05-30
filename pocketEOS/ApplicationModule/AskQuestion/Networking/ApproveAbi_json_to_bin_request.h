//
//  ApproveAbi_json_to_bin_request.h
//  pocketEOS
//
//  Created by oraclechain on 14/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface ApproveAbi_json_to_bin_request : BaseHttpsNetworkRequest

/**
 owner
 */
@property(nonatomic, copy) NSString *owner;


/**
 "spender":"ocaskans"
 */
@property(nonatomic, copy) NSString *spender;


/**
 
 */
@property(nonatomic, copy) NSString *quantity;



@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;

@end
