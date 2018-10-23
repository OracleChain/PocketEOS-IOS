//
//  Get_account_assetsService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_account_assetsService.h"

@implementation Get_account_assetsService

- (Get_account_assetsRequest *)get_account_assetsRequest{
    if (!_get_account_assetsRequest) {
        _get_account_assetsRequest = [[Get_account_assetsRequest alloc] init];
    }
    return _get_account_assetsRequest;
}

- (void)get_account_assets:(CompleteBlock)complete{
    [self.get_account_assetsRequest postOuterDataSuccess:^(id DAO, id data) {
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
