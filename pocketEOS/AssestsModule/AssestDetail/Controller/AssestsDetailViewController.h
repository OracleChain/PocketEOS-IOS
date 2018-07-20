//
//  AssestsDetailViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/28.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenInfo.h"

@interface AssestsDetailViewController : BaseViewController
@property(nonatomic, strong) TokenInfo *model;
@property(nonatomic, strong) NSString *accountName;

@property(nonatomic , strong) NSMutableArray *get_token_info_service_data_array;
@end
