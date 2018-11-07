//
//  TransferDetailsService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TransferDetailsService.h"

@implementation TransferDetailsService

- (NSMutableDictionary *)dataSourceDictionary{
    if (!_dataSourceDictionary) {
        _dataSourceDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dataSourceDictionary;
}


-(void)buildDataSource:(CompleteBlock)complete{
    
    [self.dataSourceDictionary removeAllObjects];
    
    NSArray *firstSectionNameArr = [NSArray arrayWithObjects:NSLocalizedString(@"备注", nil), nil];
    NSArray *firstSecionItemDetailArr = [NSArray arrayWithObjects:self.model.memo, nil];
    NSMutableArray *firstSecionModelArr = [NSMutableArray array];
    for (int i = 0 ; i < firstSectionNameArr.count; i++) {
        OptionModel *item = [[OptionModel alloc] init];
        item.optionName = firstSectionNameArr[i];
        item.detail = firstSecionItemDetailArr[i];
        [firstSecionModelArr addObject:item];
    }
    
    
    NSArray *secondSectionNameArr = [NSArray arrayWithObjects:NSLocalizedString(@"发起人", nil) ,NSLocalizedString(@"接收人", nil) , nil];
    NSArray *secondSecionItemDetailArr = [NSArray arrayWithObjects:self.model.from, self.model.to, nil];
    NSMutableArray *secondSecionModelArr = [NSMutableArray array];
    for (int i = 0 ; i < secondSectionNameArr.count; i++) {
        OptionModel *item = [[OptionModel alloc] init];
        item.optionName = secondSectionNameArr[i];
        item.detail = secondSecionItemDetailArr[i];
        item.canCopy = YES;
        [secondSecionModelArr addObject:item];
    }
    
    
     NSArray *thirdSectionNameArr = [NSArray arrayWithObjects:NSLocalizedString(@"所在区块", nil) ,NSLocalizedString(@"区块时间", nil), NSLocalizedString(@"CPU消耗", nil),NSLocalizedString(@"net消耗", nil), nil];
    NSArray *thirdSecionItemDetailArr = [NSArray arrayWithObjects:self.model.blockNum.stringValue, [NSDate getLocalDateTimeFromUTC:self.model.time], [NSString stringWithFormat:@"%@ us", self.model.cpu_usage_us], [NSString stringWithFormat:@"%@ bytes", self.model.net_usage_words],nil];
    NSMutableArray *thirdSecionModelArr = [NSMutableArray array];
    for (int i = 0 ; i < thirdSectionNameArr.count; i++) {
        OptionModel *item = [[OptionModel alloc] init];
        item.optionName = thirdSectionNameArr[i];
        item.detail = thirdSecionItemDetailArr[i];
        [thirdSecionModelArr addObject:item];
    }
    
    
    NSArray *fourthSectionNameArr = [NSArray arrayWithObjects:NSLocalizedString(@"Tx id", nil),NSLocalizedString(@"合约账号", nil) , nil];
    NSArray *fourthSecionItemDetailArr = [NSArray arrayWithObjects:self.model.trxid, self.model.contract, nil];
    NSMutableArray *fourthSecionModelArr = [NSMutableArray array];
    for (int i = 0 ; i < fourthSectionNameArr.count; i++) {
        OptionModel *item = [[OptionModel alloc] init];
        item.optionName = fourthSectionNameArr[i];
        item.detail = fourthSecionItemDetailArr[i];
        item.canCopy = YES;
        [fourthSecionModelArr addObject:item];
    }
    
    
   
    [self.dataSourceDictionary setObject:firstSecionModelArr forKey:@"firstSecionModelArr"];
    [self.dataSourceDictionary setObject:secondSecionModelArr forKey:@"secondSecionModelArr"];
    [self.dataSourceDictionary setObject:thirdSecionModelArr forKey:@"thirdSecionModelArr"];
    [self.dataSourceDictionary setObject:fourthSecionModelArr forKey:@"fourthSecionModelArr"];
    
    complete(self, YES);
}



//[self.dataSourceArray removeAllObjects];
//
//NSMutableArray *itemNameArr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Tx id", nil), NSLocalizedString(@"发起人", nil),NSLocalizedString(@"接收人", nil),NSLocalizedString(@"数量", nil),NSLocalizedString(@"备注", nil),NSLocalizedString(@"所在区块", nil),NSLocalizedString(@"区块时间", nil),NSLocalizedString(@"CPU消耗", nil),NSLocalizedString(@"net消耗", nil), nil];
//
//NSMutableArray *itemDetailArr = [NSMutableArray arrayWithObjects:self.model.trxid, self.model.from, self.model.to, [NSString stringWithFormat:@"%@ %@", self.model.amount, self.model.assestsType ] , self.model.memo, self.model.blockNum.stringValue, [NSDate getLocalDateTimeFromUTC:self.model.time], [NSString stringWithFormat:@"%@ us", self.model.cpu_usage_us], [NSString stringWithFormat:@"%@ bytes", self.model.net_usage_words], nil];
//
//for (int i = 0 ; i < itemNameArr.count; i++) {
//    OptionModel *item = [[OptionModel alloc] init];
//    item.optionName = itemNameArr[i];
//    item.detail = itemDetailArr[i];
//    [self.dataSourceArray addObject:item];
//}
@end
