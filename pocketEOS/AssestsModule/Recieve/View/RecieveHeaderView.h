//
//  RecieveHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecieveHeaderViewDelegate<NSObject>

- (void)selectAccountBtnDidClick:(UIButton *)sender;
- (void)selectAssestsBtnDidClick:(UIButton *)sender;
- (void)createQRCodeBtnDidClick:(UIButton *)sender;

@end

@interface RecieveHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UILabel *accountChooserLabel;
@property (weak, nonatomic) IBOutlet UILabel *assestChooserLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *generateQRCodeBtn;
@property(nonatomic, weak) id<RecieveHeaderViewDelegate> delegate;
@end
