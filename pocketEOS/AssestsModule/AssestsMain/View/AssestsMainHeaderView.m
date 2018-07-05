//
//  AssestsMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AssestsMainHeaderView.h"
#import "Account.h"
#import "Wallet.h"


@interface AssestsMainHeaderView()
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@end

@implementation AssestsMainHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.userAccountLabel.userInteractionEnabled = YES;
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint = CGPointMake(0, 0);
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        layer.colors = @[(__bridge id)HEXCOLOR(0x095CE5).CGColor, (__bridge id)HEXCOLOR(0x3574FA).CGColor];
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        layer.colors = @[(__bridge id)HEXCOLOR(0x23242A).CGColor, (__bridge id)HEXCOLOR(0x282828).CGColor];
    }
    layer.locations = @[@(0.0f), @(1.0f)];
    [self.topBackgroundView.layer addSublayer:layer];

    [self.totalAssetsLabel setFont:[UIFont boldSystemFontOfSize:36]];
    
}

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

- (IBAction)redPacketBtnDidClick:(UIButton *)sender {
    if (!self.redPacketBtnDidClickBlock) {
        return;
    }
    self.redPacketBtnDidClickBlock();
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
    Wallet *wallet = CURRENT_WALLET;
    NSString *nameStr = nil;
    if ([RegularExpression validateMobile:wallet.wallet_name]) {
        nameStr = [wallet.wallet_name substringFromIndex:wallet.wallet_name.length - 4];
    }else{
        nameStr = wallet.wallet_name ;
    }
    if (nameStr.length > 0) {
        self.userNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@的钱包", nil), VALIDATE_STRING(nameStr)];
    }else{
        self.userNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"***的钱包", nil)];
    }
    
    NSArray *accountArr = [[AccountsTableManager accountTable] selectAccountTable];
    if (accountArr.count == 0) {
        self.userAccountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"没有账号", nil)] ;
    }else{
        self.userAccountLabel.text = [NSString stringWithFormat:@"%@", VALIDATE_STRING(model.account_name) ] ;
        
    }
    
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey: Total_assets_visibel] isEqual:@1]) {
        self.totalAssetsLabel.text = [NSString stringWithFormat:@"≈%@", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.eos_balance.doubleValue * model.eos_price_cny.doubleValue + model.oct_balance.doubleValue * model.oct_price_cny.doubleValue]]];
        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_open"] forState:(UIControlStateNormal)];
    }else{
        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_close"] forState:(UIControlStateNormal)];
        self.totalAssetsLabel.text = @"******";
    }
    
}
- (IBAction)accountBtnDidClick:(UIButton *)sender {
    if (!self.accountBtnDidTapBlock) {
        return;
    }
    self.accountBtnDidTapBlock();
}

@end
