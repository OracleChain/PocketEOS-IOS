//
//  ResetAccountPermisionViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

typedef NS_ENUM(NSInteger, ResetAccountPermisionViewControllerCurrentAction) {
    ResetAccountPermisionViewControllerResetOwnerPrivateKey,
    ResetAccountPermisionViewControllerResetActivePrivateKey
};

#import "BaseViewController.h"
#import "AccountInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResetAccountPermisionViewController : BaseViewController

@property(nonatomic , assign) ResetAccountPermisionViewControllerCurrentAction resetAccountPermisionViewControllerCurrentAction;

@property(nonatomic , strong) AccountInfo *model;
@end

NS_ASSUME_NONNULL_END
