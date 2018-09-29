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
                NSMutableArray *tmpArr = result.data;
                NSMutableArray *resultArr = [NSMutableArray array];
                for (Application *app in tmpArr) {
                    if (!app.isScatter) {
                        [resultArr addObject:app];
                    }
                }
                
                
                Application *model = resultArr[0];
                [weakSelf.recommandApplicationDataArray addObject:model];
                if (resultArr.count > 1) {
                    [weakSelf.dataSourceArray addObjectsFromArray: [tmpArr subarrayWithRange:(NSMakeRange(1, resultArr.count - 1))]];
                }else{
                    [weakSelf.dataSourceArray addObjectsFromArray:resultArr];
                }
                complete(weakSelf, YES);
            }
        }
        
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];

}
@end
