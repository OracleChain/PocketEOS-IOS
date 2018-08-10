//
//  PayRegistAccountHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"
#import "CreateAccountResourceRespModel.h"


@protocol PayRegistAccountHeaderViewDelegate<NSObject>

- (void)privateKeyBeSameModeBtnDidClick:(UIButton *)sender;
- (void)privateKeyBeDiffrentModeBtnDidClick:(UIButton *)sender;
- (void)createBtnDidClick:(UIButton *)sender;
@end


@interface PayRegistAccountHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;

/**
 私钥二合一模式 (建议新手使用)
 */
@property (weak, nonatomic) IBOutlet UIButton *privateKeyBeSameModeBtn;

/**
 双私钥模式 (推荐资深用户使用)
 */
@property (weak, nonatomic) IBOutlet UIButton *privateKeyBeDiffrentModeBtn;

@property(nonatomic, weak) id<PayRegistAccountHeaderViewDelegate> delegate;

- (void)updateViewWithResourceModel:(CreateAccountResourceRespModel *)model;
@end
