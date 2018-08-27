//
//  DappExcuteActionsDataSourceService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DappExcuteActionsDataSourceService.h"
#import "ExcuteActions.h"
#import "ExcuteActionsResult.h"


@implementation DappExcuteActionsDataSourceService


-(void)buildDataSource:(CompleteBlock)complete{
    [self.dataSourceArray removeAllObjects];
    
    // read from json file
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource: @"TransferToMoreAccount" ofType:@"json"];
    NSData * jsonData = [[NSData alloc] initWithContentsOfFile: jsonPath];
    NSMutableDictionary *resultDict = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    // read from QRCode
//    NSMutableDictionary *resultDict = [self.actionsResultDict mj_JSONObject];
    
    ExcuteActionsResult *result = [ExcuteActionsResult mj_objectWithKeyValues: resultDict];
    if ([result.type isEqualToString:@"actions_QRCode"]) {
        self.dataSourceArray = [NSMutableArray arrayWithArray:result.actions];
        complete(self , YES);
    }else{
        complete(nil , NO);
    }
}

@end
