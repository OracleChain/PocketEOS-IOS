//
//  AccountManagementHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountManagementHeaderViewDelegate<NSObject>
- (void)setToMainAccountBtnDidClick:(UIButton *)sender;
- (void)exportPrivateKeyBtnDidClick:(UIButton *)sender;
@end

@interface AccountManagementHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UIButton *mainAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *exportPrivateKeyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImg;
@property(nonatomic, weak) id<AccountManagementHeaderViewDelegate> delegate;
@end
