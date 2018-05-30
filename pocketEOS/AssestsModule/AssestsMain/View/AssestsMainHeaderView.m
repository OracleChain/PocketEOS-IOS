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
@property(nonatomic, strong) UIImageView *accountQRCodeImg;
@end

@implementation AssestsMainHeaderView

- (UIImageView *)accountQRCodeImg{
    if (!_accountQRCodeImg) {
        _accountQRCodeImg = [[UIImageView alloc] init];
        _accountQRCodeImg.image = [UIImage imageNamed:@"QRCode_small_white"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpinsideAccounLabel)];
        self.userAccountLabel.userInteractionEnabled = YES;
        self.accountQRCodeImg.userInteractionEnabled = YES;
        [self.userAccountLabel addGestureRecognizer:tap];
        [self.accountQRCodeImg addGestureRecognizer:tap];
    }
    return _accountQRCodeImg;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.avatarImg.userInteractionEnabled = YES;
    self.userAccountLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImgDidTap)];
    [self.avatarImg addGestureRecognizer:tap];
    
    
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
    [self.avatarImg sd_setImageWithURL:String_To_URL(wallet.wallet_img) placeholderImage:[UIImage imageNamed:@"wallet_default_avatar"]];
    NSString *nameStr = nil;
    if ([RegularExpression validateMobile:wallet.wallet_name]) {
        nameStr = [wallet.wallet_name substringFromIndex:wallet.wallet_name.length - 4];
    }else{
        nameStr = wallet.wallet_name ;
    }
    if (nameStr.length > 0) {
        self.userNameLabel.text = [NSString stringWithFormat:@"%@的钱包", VALIDATE_STRING(nameStr)];
    }else{
        self.userNameLabel.text = [NSString stringWithFormat:@"***的钱包"];
    }
    
    NSArray *accountArr = [[AccountsTableManager accountTable] selectAccountTable];
    if (accountArr.count == 0) {
        self.userAccountLabel.text = [NSString stringWithFormat:@"没有账号"] ;
    }else{
        self.userAccountLabel.text = [NSString stringWithFormat:@"%@", VALIDATE_STRING(model.account_name) ] ;
        
    }
    
    [self addSubview:self.accountQRCodeImg];
    self.accountQRCodeImg.sd_layout.leftSpaceToView(self.userAccountLabel, 5).centerYEqualToView(self.userAccountLabel).widthIs(13).heightIs(13);
    
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey: Total_assets_visibel] isEqual:@1]) {
        self.totalAssetsLabel.text = [NSString stringWithFormat:@"≈%@", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.eos_balance.doubleValue * model.eos_price_cny.doubleValue + model.oct_balance.doubleValue * model.oct_price_cny.doubleValue]]];
        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_open"] forState:(UIControlStateNormal)];
    }else{
        [self.totalAssestsVisibleBtn setImage:[UIImage imageNamed:@"eye_close"] forState:(UIControlStateNormal)];
        self.totalAssetsLabel.text = @"******";
    }
    
}

- (void)touchUpinsideAccounLabel{
    if (!self.accountQRCodeImgDidTapBlock) {
        return;
    }
    self.accountQRCodeImgDidTapBlock();
}

- (void)avatarImgDidTap{
    if (!self.avatarImgDidTapBlock) {
        return;
    }
    self.avatarImgDidTapBlock();
}
@end
