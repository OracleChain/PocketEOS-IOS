//
//  RichlistDetailHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "RichlistDetailHeaderView.h"
#import "Account.h"
#import "Wallet.h"

@implementation RichlistDetailHeaderView

- (IBAction)changeAccount:(UIButton *)sender {
    if (!self.changeAccountBtnDidClickBlock) {
        return;
    }
    self.changeAccountBtnDidClickBlock();
}

- (IBAction)transferBtnDidClick:(UIButton *)sender {
    if (!self.transferBtnDidClickBlock) {
        return;
    }
    self.transferBtnDidClickBlock();
}

-(void)setModel:(Account *)model{
    
    self.userAccountLabel.text = [NSString stringWithFormat:@"%@", model.account_name] ;
    self.totalAssetsLabel.text = [NSString stringWithFormat:@"≈%@", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.eos_balance.doubleValue * model.eos_price_cny.doubleValue + model.oct_balance.doubleValue * model.oct_price_cny.doubleValue]]];
}
@end
