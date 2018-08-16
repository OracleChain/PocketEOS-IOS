//
//  ExcuteActionsDataSourceService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/10.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ExcuteActionsDataSourceService.h"
#import "Abi_json_to_binRequest.h"
#import "ExcuteActions.h"
#import "ExcuteActionsResult.h"
#import "Abi_json_to_bin_Result.h"
#import "Abi_json_to_bin.h"

@interface ExcuteActionsDataSourceService()

@end


@implementation ExcuteActionsDataSourceService


-(void)buildDataSource:(CompleteBlock)complete{
    [self.dataSourceArray removeAllObjects];
    
    // read from json file
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource: @"create_account" ofType:@"json"];
//    NSData * jsonData = [[NSData alloc] initWithContentsOfFile: jsonPath];
//    NSMutableDictionary *resultDict = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingMutableLeaves error:nil];
    
// read from QRCode
    NSMutableDictionary *resultDict = [self.actionsResultDict mj_JSONObject];
    
    ExcuteActionsResult *result = [ExcuteActionsResult mj_objectWithKeyValues: resultDict];
    if ([result.type isEqualToString:@"actions_QRCode"]) {
        self.dataSourceArray = [NSMutableArray arrayWithArray:result.actions];
        complete(self , YES);
    }else{
        complete(nil , NO);
    }
}
@end
