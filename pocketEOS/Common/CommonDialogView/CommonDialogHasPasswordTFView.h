//
//  CommonDialogHasPasswordTFView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommonDialogHasPasswordTFViewDelegate<NSObject>
- (void)commonDialogHasPasswordTFViewSkipBtnDidClick:(UIButton *)sender;
- (void)commonDialogHasPasswordTFViewConfirmBtnDidClick:(UIButton *)sender;
@end


@interface CommonDialogHasPasswordTFView : UIView
@property(nonatomic , strong) OptionModel *model;

@property(nonatomic, weak) id<CommonDialogHasPasswordTFViewDelegate> delegate;

@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UITextField *passwordTF;
@end

NS_ASSUME_NONNULL_END
