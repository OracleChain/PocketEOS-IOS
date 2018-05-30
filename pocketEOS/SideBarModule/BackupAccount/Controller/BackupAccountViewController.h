//
//  BackupAccountViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"

/**
 从哪个页面跳转过来
 */
typedef NS_ENUM(NSInteger, BackupAccountViewControllerFromVC) {
    BackupAccountViewControllerFromPocketManagementVC,
    BackupAccountViewControllerFromCreatePocketVC
};

@interface BackupAccountViewController : BaseViewController
@property(nonatomic , strong) NSString *accountName;
@property(nonatomic , assign) BackupAccountViewControllerFromVC backupAccountViewControllerFromVC;
@end
