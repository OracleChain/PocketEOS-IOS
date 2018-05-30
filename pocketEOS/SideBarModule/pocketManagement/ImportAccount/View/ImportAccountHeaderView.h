//
//  ImportAccountHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/12.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImportAccountHeaderViewDelegate<NSObject>

- (void)importWithQRCodeBtnDidClick:(UIButton *)sender;
- (void)importBtnDidClick:(UIButton *)sender;

@end

@interface ImportAccountHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;

@property (weak, nonatomic) IBOutlet UITextField *private_ownerKey_TF;
@property (weak, nonatomic) IBOutlet UITextField *private_activeKey_tf;

@property(nonatomic, weak) id<ImportAccountHeaderViewDelegate> delegate;

@end
