//
//  PhoneLoginMainView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhoneLoginMainViewDelegate<NSObject>

- (void)getVerifyBtnDidClick:(UIButton *)sender;
- (void)loginBtnDidClick:(UIButton *)sender;
- (void)areaCodeBtnDidClick;

@end

@interface PhoneLoginMainView : UIView
@property(nonatomic, weak) id<PhoneLoginMainViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLabel;



@end
