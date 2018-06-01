//
//  BaseViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"


@interface BaseViewController : UIViewController


@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, strong) UICollectionView *mainCollectionView;



/**
 *  显示没有数据页面
 */
+ (void)showNoDataViewWithImageName:(NSString *)imageName andTitleStr:(NSString *)titleStr toView:(UIView *)parentView andViewController:(UIViewController *) viewController;

/**
 *  移除无数据页面
 */
-(void)removeNoDataView;
@end
