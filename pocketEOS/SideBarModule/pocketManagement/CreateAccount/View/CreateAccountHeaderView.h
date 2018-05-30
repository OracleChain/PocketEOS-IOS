//
//  CreateAccountHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateAccountHeaderViewDelegate<NSObject>
@optional
- (void)agreeTermBtnDidClick:(UIButton *)sender;
- (void)createAccountBtnDidClick:(UIButton *)sender;
- (void)privacyPolicyBtnDidClick:(UIButton *)sender;
@end

@interface CreateAccountHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;
@property (weak, nonatomic) IBOutlet UIButton *agreeItemBtn;
@property(nonatomic, weak) id<CreateAccountHeaderViewDelegate> delegate;
@end
