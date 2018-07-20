//
//  Get_token_info_service.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "Get_token_info_request.h"

@interface Get_token_info_service : BaseService
@property(nonatomic , strong) Get_token_info_request *get_token_info_request;

- (void)get_token_info:(CompleteBlock)complete;
@end
