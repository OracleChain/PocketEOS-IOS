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
@property (weak, nonatomic) IBOutlet UIImageView *addAssestsImageView;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@end

@implementation AssestsMainHeaderView

- (NSMutableArray *)tokenInfoDataArray{
    if (!_tokenInfoDataArray) {
        _tokenInfoDataArray = [[NSMutableArray alloc] init];
    }
    return _tokenInfoDataArray;
}

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
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAssestsImageDidTap)];
    [self.addAssestsImageView addGestureRecognizer:tap];
    
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
    if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE) {
        [TOASTVIEW showWithText:NSLocalizedString(@"请移步至社交模式", nil)];
        return;
    }else{
        if (!self.redPacketBtnDidClickBlock) {
            return;
        }
        self.redPacketBtnDidClickBlock();
        
    }
}


- (IBAction)ramTradeBtnDidClick:(UIButton *)sender {
    if (!self.ramTradeBtnDidClickBlock) {
        return;
    }
    self.ramTradeBtnDidClickBlock();
}




- (IBAction)totalAssestVisible:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.isSelected] forKey: Total_assets_visibel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey: Total_assets_visibel]);
    [self updateViewWithDataArray:self.tokenInfoDataArray];
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
        self.userNameLabel.text = [NSString stringWithFormat: @"%@%@", VALIDATE_STRING(nameStr), NSLocalizedString(@"的钱包", nil)];
    }else{
        self.userNameLabel.text = [NSString stringWithFormat: @"***%@", NSLocalizedString(@"的钱包", nil)];
    }
    
    NSArray *accountArr = [[AccountsTableManager accountTable] selectAccountTable];
    if (accountArr.count == 0) {
        self.userAccountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"没有账号", nil)] ;
    }else{
        self.userAccountLabel.text = [NSString stringWithFormat:@"%@", VALIDATE_STRING(model.account_name) ] ;
        
    }
    
//    if ( [[[NSUserDefaults standardUserDefaults] objectForKey: Total_assets_visibel] isEqual:@1]) {
//        self.totalAssetsLabel.text = [NSString stringWithFormat:@"≈%@", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.eos_balance.doubleValue * model.eos_price_cny.doubleValue + model.oct_balance.doubleValue * model.oct_price_cny.doubleValue]]];
//        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_open"] forState:(UIControlStateNormal)];
//    }else{
//        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_close"] forState:(UIControlStateNormal)];
//        self.totalAssetsLabel.text = @"******";
//    }
    
}


- (void)updateViewWithDataArray:(NSMutableArray<TokenInfo *> *)dataArray{
    self.tokenInfoDataArray = dataArray;
    double totalBalanceCnyValue =0;
    for (TokenInfo *model in dataArray) {
        totalBalanceCnyValue += model.balance_cny.doubleValue;
    }
    
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey: Total_assets_visibel] isEqual:@1]) {
        self.totalAssetsLabel.text = [NSString stringWithFormat:@"≈%.4f", totalBalanceCnyValue];
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

- (void)addAssestsImageDidTap{
    if (!self.addAssestsImgDidTapBlock) {
        return;
    }
    self.addAssestsImgDidTapBlock();
}

@end
