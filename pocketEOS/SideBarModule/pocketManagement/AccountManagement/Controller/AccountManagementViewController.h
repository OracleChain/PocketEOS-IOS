//
//  AccountManagementViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@interface AccountManagementViewController : BaseViewController
@property(nonatomic, strong) AccountInfo *model;
@end
