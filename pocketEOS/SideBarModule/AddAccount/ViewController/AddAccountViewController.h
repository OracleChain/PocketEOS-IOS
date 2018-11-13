//
//  AddAccountViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"

/**
 从那个模式下跳转过来
 */
typedef NS_ENUM(NSInteger, AddAccountViewControllerFromMode) {
    AddAccountViewControllerFromLoginPage,
    AddAccountViewControllerFromOtherPage
};

@interface AddAccountViewController : BaseViewController
@property(nonatomic , assign) AddAccountViewControllerFromMode addAccountViewControllerFromMode;
@end
