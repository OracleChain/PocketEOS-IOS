//
//  BBAssestsMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 15/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BBAssestsMainHeaderView.h"
#import "Account.h"
#import "Wallet.h"

@interface BBAssestsMainHeaderView()
@end


@implementation BBAssestsMainHeaderView
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
- (IBAction)recieveBtnDidClick:(UIButton *)sender {
    if (!self.recieveBtnDidClickBlock) {
        return;
    }
    self.recieveBtnDidClickBlock();
}
- (IBAction)totalAssestVisible:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.isSelected] forKey: Total_assets_visibel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey: Total_assets_visibel]);
    if (_model) {
        [self setModel:_model];
    }
}

-(void)setModel:(Account *)model{
    _model = model;
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey: Total_assets_visibel] isEqual:@1]) {
        self.totalAssetsLabel.text = [NSString stringWithFormat:@"≈%@", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.eos_balance.doubleValue * model.eos_price_cny.doubleValue + model.oct_balance.doubleValue * model.oct_price_cny.doubleValue]]];
        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_open"] forState:(UIControlStateNormal)];
    }else{
        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_close"] forState:(UIControlStateNormal)];
        self.totalAssetsLabel.text = @"******";
    }
}
@end
