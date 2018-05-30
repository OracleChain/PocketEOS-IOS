//
//  RedpacketService.m
//  pocketEOS
//
//  Created by oraclechain on 16/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedpacketService.h"
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

- (void)sendRedPacket:(CompleteBlock)complete{
    [self.sendRedpacketRequest postDataSuccess:^(id DAO, id data) {
        if ([data[@"data"] isKindOfClass:[NSDictionary class]]) {
            [TOASTVIEW showWithText:data[@"data"][@"msg"]];
            RedPacket *result = [RedPacket mj_objectWithKeyValues:data[@"data"]];
            complete(result , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

- (void)getRedPacketDetail:(CompleteBlock)complete{
    
    [self.getRedPacketDetailRequest getDataSusscess:^(id DAO, id data) {
        if ([data[@"data"] isKindOfClass:[NSDictionary class]]) {
            [TOASTVIEW showWithText:data[@"data"][@"msg"]];
            RedPacketDetail *result = [RedPacketDetail mj_objectWithKeyValues:data[@"data"]];
            NSLog(@"%@", [result mj_JSONObject]);
            complete(result , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

-(void)buildDataSource:(CompleteBlock)complete{
    [self.getRedPacketRecordRequest getDataSusscess:^(id DAO, id data) {
        WS(weakSelf);
        if ([data isKindOfClass:[NSDictionary class]]) {
            RedPacketRecordResult *result = [RedPacketRecordResult mj_objectWithKeyValues:data];
            weakSelf.responseArray = [NSMutableArray arrayWithArray:result.data];
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
            complete(@(result.data.count) , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

@end
