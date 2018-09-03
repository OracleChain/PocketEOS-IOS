//
//  RedpacketService.m
//  pocketEOS
//
//  Created by oraclechain on 16/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedpacketService.h"
#import "RedPacketResult.h"
#import "RedPacket.h"
#import "RedPacketRecordResult.h"
#import "RedPacketRecord.h"
#import "RedPacketDetail.h"
#import "RedPacketDetailSingleAccount.h"


@implementation RedpacketService

- (SendRedpacketRequest *)sendRedpacketRequest{
    if (!_sendRedpacketRequest) {
        _sendRedpacketRequest = [[SendRedpacketRequest alloc] init];
    }
    return _sendRedpacketRequest;
}

- (GetRedPacketRecordRequest *)getRedPacketRecordRequest{
    if (!_getRedPacketRecordRequest) {
        _getRedPacketRecordRequest = [[GetRedPacketRecordRequest alloc] init];
    }
    return _getRedPacketRecordRequest;
}
- (GetRedPacketDetailRequest *)getRedPacketDetailRequest{
    if (!_getRedPacketDetailRequest) {
        _getRedPacketDetailRequest = [[GetRedPacketDetailRequest alloc] init];
    }
    return _getRedPacketDetailRequest;
}

- (PayOrderRequest *)payOrderRequest{
    if (!_payOrderRequest) {
        _payOrderRequest = [[PayOrderRequest alloc] init];
    }
    return _payOrderRequest;
}


- (void)sendRedPacket:(CompleteBlock)complete{
    [self.sendRedpacketRequest postDataSuccess:^(id DAO, id data) {
        RedPacketResult *result = [RedPacketResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText:result.message];
            complete(nil, NO);
        }else{
            complete(result.data , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)getRedPacketDetail:(CompleteBlock)complete{
    
    [self.getRedPacketDetailRequest postDataSuccess:^(id DAO, id data) {
        BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.message];
            complete(nil , NO);
        }else{
            RedPacketDetail *result = [RedPacketDetail mj_objectWithKeyValues:data[@"data"]];
            NSLog(@"%@", [result mj_JSONObject]);
            complete(result , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

-(void)buildDataSource:(CompleteBlock)complete{
    [self.getRedPacketRecordRequest postDataSuccess:^(id DAO, id data) {
        WS(weakSelf);
        if ([data isKindOfClass:[NSDictionary class]]) {
            [weakSelf.responseArray removeAllObjects];
            [weakSelf.dataSourceArray removeAllObjects];
            
            RedPacketRecordResult *result = [RedPacketRecordResult mj_objectWithKeyValues:data];
            if (![result.code isEqualToNumber:@0]) {
                [TOASTVIEW showWithText: result.msg];
                complete(nil , NO);
            }else{
                weakSelf.responseArray = [NSMutableArray arrayWithArray:result.data];
                weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
                complete(@(result.data.count) , YES);
            }
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
        
    }];
}

- (void)payOrder:(CompleteBlock)complete{
    [self.payOrderRequest postOuterDataSuccess:^(id DAO, id data) {
        BaseResult *result = [BaseResult mj_objectWithKeyValues:data];
        if ([result.code isEqualToNumber:@0]) {
            complete(result , YES);
        }else{
            [TOASTVIEW showWithText:result.message];
            complete(nil, NO);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
    
}



@end
