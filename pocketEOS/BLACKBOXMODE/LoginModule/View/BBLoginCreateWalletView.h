//
//  BBLoginCreateWalletView.h
//  pocketEOS
//
//  Created by oraclechain on 14/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBLoginCreateWalletViewDelegate<NSObject>
- (void)nextStepBtnDidClick;
- (void)explainBlackBoxModeBtnDidClick;
- (void)privacyPolicyBtnDidClick:(UIButton *)sender;
- (void)agreeTermBtnDidClick:(UIButton *)sender;
@end


@interface BBLoginCreateWalletView : UIView
@property(nonatomic, weak) id<BBLoginCreateWalletViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *agreeTermBtn;

@property (weak, nonatomic) IBOutlet UITextField *walletNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;




@end
