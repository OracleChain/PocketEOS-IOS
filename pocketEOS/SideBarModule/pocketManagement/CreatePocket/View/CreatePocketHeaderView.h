//
//  CreatePocketHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CreatePocketHeaderViewDelegate<NSObject>
- (void)createPocketBtnDidClick:(UIButton *)sender;
- (void)privacyPolicyBtnDidClick:(UIButton *)sender;
- (void)agreeTermBtnDidClick:(UIButton *)sender;
@end


@interface CreatePocketHeaderView : BaseView
@property(nonatomic, weak) id<CreatePocketHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *agreeTermBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@end
