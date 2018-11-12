//
//  ExcuteActionsDataSourceService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/10.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ExcuteActionsDataSourceService.h"
#import "ExcuteActions.h"
#import "ExcuteActionsResult.h"

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
        complete(result , YES);
    }else{
        complete(nil , NO);
    }
}

- (void)notifyDappServerExcuteActionsResultWithNotifyDappServerResult:(NotifyDappServerResult *)result{
    NSString *notifyUrl = [NSString stringWithFormat:@"%@?result=%@&txID=%@&serialNumber=%@",result.callback,  result.result , result.txID, result.serialNumber];
    AFHTTPSessionManager *outerNetworkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: REQUEST_BASEURL]];
    [outerNetworkingManager GET:VALIDATE_STRING(notifyUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}
@end
