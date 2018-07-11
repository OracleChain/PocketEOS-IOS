//
//  SystemSettingService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/17.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "SystemSettingService.h"

@implementation SystemSettingService

- (NSDictionary *)dataSourceDictionary{
    if (!_dataSourceDictionary) {
        _dataSourceDictionary = @{
                                  @"topSection" : @[NSLocalizedString(@"意见反馈", nil)]  ,
                                  @"bottomSection" : @[NSLocalizedString(@"清空缓存", nil),NSLocalizedString(@"语言", nil), NSLocalizedString(@"法律条款与隐私政策", nil), NSLocalizedString(@"关于Pocket EOS", nil)]
                                  };
    }
    return _dataSourceDictionary;
}

-(void)buildDataSource:(CompleteBlock)complete{
    
    
    complete(self , YES);
}
@end
