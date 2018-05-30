//
//  RichlistDetailViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Follow;
@interface RichlistDetailViewController : BaseViewController

/**
 followType :  1 表示钱包 2 表示账号
 */
@property(nonatomic, strong) Follow *model;
@end
