//
//  Abi_to_json.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Abi_json_to_binRequest : BaseHttpsNetworkRequest

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic , strong) NSDictionary *args;

@end

