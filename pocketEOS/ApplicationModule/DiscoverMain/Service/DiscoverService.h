//
//  DiscoverService.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "Get_recommend_dapp_request.h"
#import "Get_category_config_request.h"
#import "Get_dapp_by_config_id_request.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverService : BaseService

@property(nonatomic , strong) Get_recommend_dapp_request *get_recommend_dapp_request;
@property(nonatomic , strong) Get_category_config_request *get_category_config_request;
@property(nonatomic , strong) Get_dapp_by_config_id_request *get_dapp_by_config_id_request;


- (void)get_recommend_dapp:(CompleteBlock)complete;
- (void)get_category_config:(CompleteBlock)complete;
- (void)get_dapp_by_config_id:(CompleteBlock)complete;





@property(nonatomic , strong) NSMutableArray *category_configDataSourceArray;



@end

NS_ASSUME_NONNULL_END
