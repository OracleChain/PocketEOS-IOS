//
//  LoginView.h
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate<NSObject>

- (void)dismiss;
- (void)changeToBlackBoxMode;
- (void)getVerifyBtnDidClick:(UIButton *)sender;
- (void)loginBtnDidClick:(UIButton *)sender;
- (void)wechatLoginBtnDidClick:(UIButton *)sender;
- (void)qqLoginBtnDidClick:(UIButton *)sender;
- (void)privacyPolicyBtnDidClick:(UIButton *)sender;

@end

@interface LoginView : UIView
@property(nonatomic, weak) id<LoginViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeTermBtn;





@end
