//
//  Abi_bin_to_json_Result.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseResult.h"
#import "Abi_bin_to_json.h"

@interface Abi_bin_to_json_Result : BaseResult

@property(nonatomic , strong) Abi_bin_to_json *data;

@end
