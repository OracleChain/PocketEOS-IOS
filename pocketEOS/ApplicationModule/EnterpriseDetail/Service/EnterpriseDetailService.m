//
//  EnterpriseDetailService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "EnterpriseDetailService.h"
#import "ApplicationsResult.h"
#import "Application.h"

@implementation EnterpriseDetailService

- (GetEnterpriseDetailRequest *)getEnterpriseDetailRequest{
    if (!_getEnterpriseDetailRequest) {
        _getEnterpriseDetailRequest = [[GetEnterpriseDetailRequest alloc] init];
    }
    return _getEnterpriseDetailRequest;
}

- (NSMutableArray *)recommandApplicationDataArray{
    if (!_recommandApplicationDataArray) {
        _recommandApplicationDataArray = [[NSMutableArray alloc] init];
    }
    return _recommandApplicationDataArray;
}


-(void)buildDataSource:(CompleteBlock)complete{
    WS(weakSelf);
    [weakSelf.recommandApplicationDataArray removeAllObjects];
    [weakSelf.dataSourceArray removeAllObjects];
    
    [self.getEnterpriseDetailRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            ApplicationsResult *result = [ApplicationsResult mj_objectWithKeyValues:data];
            if (result.data.count > 0) {
                Application *model = result.data[0];
                [weakSelf.recommandApplicationDataArray addObject:model];
                if (result.data.count > 1) {
                    [weakSelf.dataSourceArray addObjectsFromArray: [result.data subarrayWithRange:(NSMakeRange(1, result.data.count - 1))]];
                }else{
                    [weakSelf.dataSourceArray addObjectsFromArray:result.data];
                }
                complete(weakSelf, YES);
            }
        }
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];

}
@end
