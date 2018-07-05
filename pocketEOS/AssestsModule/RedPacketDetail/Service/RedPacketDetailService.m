//
//  RedPacketDetailService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketDetailService.h"
#import "RedPacketDetail.h"

@implementation RedPacketDetailService

-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    [self.getRedPacketDetailRequest postDataSuccess:^(id DAO, id data) {
        if (![data[@"code"] isEqualToNumber:@0]) {
            [TOASTVIEW showWithText:data[@"data"][@"msg"]];
            complete(nil, NO);
        }else{
            [weakSelf.responseArray removeAllObjects];
            [weakSelf.dataSourceArray removeAllObjects];
            RedPacketDetail *result = [RedPacketDetail mj_objectWithKeyValues:data[@"data"]];
            weakSelf.responseArray = [NSMutableArray arrayWithArray:result.redPacketOrderRedisDtos];
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
            complete(@(result.redPacketOrderRedisDtos.count) , YES);
        }
    } failure:^(id DAO, NSError *error) {
         complete(nil, NO);
    }];
    
}
@end
