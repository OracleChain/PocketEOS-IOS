//
//  ChangeAccountViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/6.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 从网络请求获取的Account数组, 还是从本地获取的Account数据
 */
typedef NS_ENUM(NSInteger, ChangeAccountDataArrayType) {
    ChangeAccountDataArrayTypeLocal = 0,
    ChangeAccountDataArrayTypeNetworking ,
};


@protocol ChangeAccountViewControllerDelegate<NSObject>
- (void)changeAccountCellDidClick:(NSString *)name;
@end

@class Account;
@interface ChangeAccountViewController : BaseViewController


/**
 从网络请求获取的Account数组, 还是从本地获取的Account数据
 */
@property(nonatomic, assign) ChangeAccountDataArrayType changeAccountDataArrayType;


@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, weak) id<ChangeAccountViewControllerDelegate> delegate;
@end
