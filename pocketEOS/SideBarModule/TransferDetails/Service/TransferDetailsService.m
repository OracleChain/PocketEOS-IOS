//
//  TransferDetailsService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TransferDetailsService.h"

@implementation TransferDetailsService


-(void)buildDataSource:(CompleteBlock)complete{
    
    [self.dataSourceArray removeAllObjects];
    
    NSMutableArray *itemNameArr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Tx id", nil), NSLocalizedString(@"发起人", nil),NSLocalizedString(@"接收人", nil),NSLocalizedString(@"数量", nil),NSLocalizedString(@"备注", nil),NSLocalizedString(@"所在区块", nil),NSLocalizedString(@"区块时间", nil),NSLocalizedString(@"CPU消耗", nil),NSLocalizedString(@"net消耗", nil), nil];
    
    NSMutableArray *itemDetailArr = [NSMutableArray arrayWithObjects:self.model.trxid, self.model.from, self.model.to, [NSString stringWithFormat:@"%@ %@", self.model.amount, self.model.assestsType ] , self.model.memo, self.model.blockNum.stringValue, [NSDate getLocalDateTimeFromUTC:self.model.time], [NSString stringWithFormat:@"%@ us", self.model.cpu_usage_us], [NSString stringWithFormat:@"%@ bytes", self.model.net_usage_words], nil];
    
    for (int i = 0 ; i < itemNameArr.count; i++) {
        OptionModel *item = [[OptionModel alloc] init];
        item.optionName = itemNameArr[i];
        item.detail = itemDetailArr[i];
        [self.dataSourceArray addObject:item];
    }
}

@end
