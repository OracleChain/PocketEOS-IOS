//
//  ScatterMainViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/17.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Application.h"

@interface ScatterMainViewController : UIViewController

@property(nonatomic , strong) Application *model;

@property(nonatomic, strong) NSString *choosedAccountName;

@end
