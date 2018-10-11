//
//  AccountAuthorizationView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/10.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountAuthorizationViewDelegate<NSObject>
- (void)accountAuthorizationViewConfirmBtnDidClick;
@end


@interface AccountAuthorizationView : BaseView
@property(nonatomic, weak) id<AccountAuthorizationViewDelegate> delegate;




- (void)updateViewWithModel:(OptionModel *)model;



@property(nonatomic , strong) UITextField *passwordTF;

@end
