//
//  ConfirmPasswordView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmPasswordViewDelegate<NSObject>
- (void)cancleBtnDidClick:(UIButton *)sender;
- (void)confirmPasswordBtnDidClick:(UIButton *)sender;
@end


@interface ConfirmPasswordView : UIView

@property(nonatomic, weak) id<ConfirmPasswordViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@end
