//
//  TransferHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TransferHeaderViewDelegate<NSObject>

- (void)selectAccountBtnDidClick:(UIButton *)sender;
- (void)selectAssestsBtnDidClick:(UIButton *)sender;
- (void)contactBtnDidClick:(UIButton *)sender;
- (void)transferBtnDidClick:(UIButton *)sender;

@end

@interface TransferHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UILabel *accountChooserLabel;
@property (weak, nonatomic) IBOutlet UILabel *assestChooserLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;

@property (weak, nonatomic) IBOutlet UILabel *assest_balanceLabel;

/**
 以人民币或美元的形式转换
 */
@property (weak, nonatomic) IBOutlet UILabel *assest_balance_ConvertLabel;


/**
 输入的金额对应的人民币或美元
 */
@property (weak, nonatomic) IBOutlet UILabel *amount_ConvertLabel;


// 备注
@property (weak, nonatomic) IBOutlet UITextView *memoTV;

@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property(nonatomic, weak) id<TransferHeaderViewDelegate> delegate;

@end
