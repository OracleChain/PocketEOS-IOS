//
//  RichListCell.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/26.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Follow;
@class WalletAccount;
@class AccountInfo;
@interface RichListCell : BaseTableViewCell

@property(nonatomic, strong) Follow *model;


/**
 网络解析的 account
 */
@property(nonatomic, strong) WalletAccount *walletAccount;


/**
 本地存的 account
 */
@property(nonatomic, strong) AccountInfo *accountInfo;
@end
