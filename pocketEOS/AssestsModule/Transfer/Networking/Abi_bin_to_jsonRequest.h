//
//  Abi_bin_to_jsonRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Abi_bin_to_jsonRequest : BaseHttpsNetworkRequest

@property(nonatomic , copy) NSString *code;


@property(nonatomic , copy) NSString *action;


@property(nonatomic , copy) NSString *binargs;
@end


