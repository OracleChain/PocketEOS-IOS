//
//  CandyCollectionMainService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "CommonTransferModel.h"
#import "ExcuteActions.h"
#import "Get_account_assetsRequest.h"
#import "TokenInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssestsCollectionMainService : BaseService

@property(nonatomic , strong) TokenInfo *currentToken;
@property(nonatomic , strong) Get_account_assetsRequest *get_account_assetsRequest;

- (void)buildExcuteActionsArrayWithTransferModel:(NSArray<CommonTransferModel *> *)modelArr andComplete:(CompleteBlock)complete;

@end

NS_ASSUME_NONNULL_END
