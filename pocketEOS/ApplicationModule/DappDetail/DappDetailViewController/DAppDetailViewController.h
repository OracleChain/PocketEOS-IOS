//
//  DAppDetailViewController.h
//  pocketEOS
//
//  Created by oraclechain on 09/05/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Application.h"



@interface DAppDetailViewController : BaseViewController
@property(nonatomic , strong) Application *model;

@property(nonatomic, strong) NSString *choosedAccountName;
@end
