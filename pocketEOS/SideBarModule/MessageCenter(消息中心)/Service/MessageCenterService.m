//
//  MessageCenterService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "MessageCenterService.h"
#import "MessageCenterResult.h"
#import "MessageCenter.h"

@implementation MessageCenterService

- (GetMessageListRequest *)getMessageListRequest{
    if (!_getMessageListRequest) {
        _getMessageListRequest = [[GetMessageListRequest alloc] init];
    }
    return _getMessageListRequest;
}

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.getMessageListRequest.size = @(15);
    self.getMessageListRequest.offset = @(0);
    [self.getMessageListRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        
        MessageCenterResult *result = [MessageCenterResult mj_objectWithKeyValues:data];
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

- (void)buildNextPageDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    self.getMessageListRequest.size = @(15);
    self.getMessageListRequest.offset = @(self.dataSourceArray.count);
    [self.getMessageListRequest postDataSuccess:^(id DAO, id data) {
        
        [weakSelf.responseArray removeAllObjects];
        
        MessageCenterResult *result = [MessageCenterResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: VALIDATE_STRING(result.message)];
        }else{
            [weakSelf.responseArray addObjectsFromArray:VALIDATE_ARRAY(result.data)];
            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
        }
        complete(@(result.data.count) , YES);
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}
@end
