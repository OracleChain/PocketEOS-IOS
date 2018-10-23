//
//  DappWithoutPasswordView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/12.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DappWithoutPasswordViewDelegate <NSObject>

- (void)dappWithoutPasswordViewBackgroundViewDidClick;

- (void)dappWithoutPasswordViewCancleDidClick;
- (void)dappWithoutPasswordViewConfirmBtnDidClick;
@end

@interface DappWithoutPasswordView : BaseView
@property(nonatomic, weak) id<DappWithoutPasswordViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *savePasswordBtn;


@end

NS_ASSUME_NONNULL_END
