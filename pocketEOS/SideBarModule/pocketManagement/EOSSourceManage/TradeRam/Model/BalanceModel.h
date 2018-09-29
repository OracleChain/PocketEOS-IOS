//
//  BalanceModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseResult.h"

@interface BalanceModel : BaseResult
@property(nonatomic , strong) NSNumber *code;
@property(nonatomic , copy) NSString *balance;
@property(nonatomic , copy) NSString *message;
@end
