//
//  AddAccountMainService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AddAccountMainService.h"

@implementation AddAccountMainService

-(void)buildDataSource:(CompleteBlock)complete{
    NSMutableArray *itemArr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"导入账号", nil), NSLocalizedString(@"创建账号", nil), NSLocalizedString(@"我是VIP", nil), NSLocalizedString(@"限时免费", nil), nil];
    NSMutableArray *itemDetailArr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"使用已有的EOS账号", nil), NSLocalizedString(@"支付费用创建新EOS账号", nil), NSLocalizedString(@"填写注册码免费创建EOS账号", nil), NSLocalizedString(@"不定期开放，敬请关注", nil), nil];
    NSMutableArray *iconArr = [NSMutableArray arrayWithObjects:@"import_account", @"pay_create_account", @"vip_create_account", @"free_create_account",nil];
    NSMutableArray *iconArr_BB = [NSMutableArray arrayWithObjects:@"import_account", @"pay_create_account", @"vip_create_account", @"free_create_account",nil];
    for (int i = 0; i < itemArr.count; i++) {
        OptionModel *model = [[OptionModel alloc] init];
        model.optionName = itemArr[i];
        model.detail = itemDetailArr[i];
        model.optionNormalIcon = iconArr[i];
        model.optionBlackBoxNormalIcon = iconArr_BB[i];
        [self.dataSourceArray addObject:model];
    }
}

@end
