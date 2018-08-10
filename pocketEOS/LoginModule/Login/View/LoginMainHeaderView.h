//
//  LoginMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginMainHeaderViewDelegate<NSObject>
- (void)changeToBlackBoxMode;
- (void)loginBtnDidClick:(UIButton *)sender;
- (void)wechatLoginBtnDidClick:(UIButton *)sender;
- (void)privacyPolicyLabelDidTap;
@end

@interface LoginMainHeaderView : UIView

@property(nonatomic, weak) id<LoginMainHeaderViewDelegate> delegate;

@end
