//
//  CreateAccountResourceResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/7.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseResult.h"
#import "CreateAccountResourceRespModel.h"

@interface CreateAccountResourceResult : BaseResult
@property(nonatomic , strong) CreateAccountResourceRespModel *data;
@end
