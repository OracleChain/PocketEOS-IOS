//
//  BaseTabBarController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController
/**
 *  显示TabBar
 */
- (void)showTabBar;
/**
 *  隐藏TabBar
 */
- (void)dismissTabBar;

- (void)setSelectedIndex:(NSUInteger)selectedIndex;

@end
