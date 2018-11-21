//
//  ImportAccountWithoutAccountNameService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "Get_key_accounts_request.h"
#import "EOSMappingResult.h"
#import "ImportAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImportAccountWithoutAccountNameService : BaseService


@property(nonatomic , copy) NSString *public_key;

- (void)get_key_accounts:(CompleteBlock)complete;

@end

NS_ASSUME_NONNULL_END
