//
//  BindPhoneNumberHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindPhoneNumberHeaderViewDelegate<NSObject>
- (void)getVerifyCodeBtnDidClick:(UIButton *)sender;
- (void)bindBtnDidClick:(UIButton *)sender;
- (void)privacyPolicyBtnDidClick:(UIButton *)sender;
@end

@interface BindPhoneNumberHeaderView : BaseView

@property(nonatomic, weak) id<BindPhoneNumberHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeTermBtn;

@end
