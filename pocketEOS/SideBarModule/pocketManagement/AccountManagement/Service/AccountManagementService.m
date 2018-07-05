//
//  AccountManagementService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "AccountManagementService.h"

@implementation AccountManagementService

- (void)buildDataSource:(CompleteBlock)complete{
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        self.dataSourceArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"设为主账号", nil),NSLocalizedString(@"保护隐私", nil), NSLocalizedString(@"EOS资源管理", nil), NSLocalizedString(@"导出私钥", nil), NSLocalizedString(@"EOS一键赎回", nil), nil];
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.dataSourceArray = [NSMutableArray arrayWithObjects: NSLocalizedString(@"EOS资源管理", nil), NSLocalizedString(@"导出私钥", nil),NSLocalizedString(@"EOS一键赎回", nil), nil];
    }
}
@end
