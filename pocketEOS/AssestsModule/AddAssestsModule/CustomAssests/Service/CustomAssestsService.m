//
//  CustomAssestsService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CustomAssestsService.h"
#import "CustomTokensResult.h"
#import "RecommandToken.h"


@implementation CustomAssestsService

- (Get_user_custom_token_request *)get_user_custom_token_request{
    if (!_get_user_custom_token_request) {
        _get_user_custom_token_request = [[Get_user_custom_token_request alloc] init];
    }
    return _get_user_custom_token_request;
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    [self.get_user_custom_token_request getDataSusscess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        
        CustomTokensResult *result = [CustomTokensResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
        }
        
        complete(@(result.data.count) , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}


@end
