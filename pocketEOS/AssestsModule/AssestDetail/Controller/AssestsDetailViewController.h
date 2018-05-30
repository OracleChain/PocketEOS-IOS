//
//  AssestsDetailViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assests.h"

@interface AssestsDetailViewController : BaseViewController
@property(nonatomic, strong) Assests *model;
@property(nonatomic, strong) NSString *accountName;
@end
