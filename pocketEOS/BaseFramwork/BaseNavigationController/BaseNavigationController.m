//
//  BaseNavigationController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTabBarController.h"
#import "AssestsMainViewController.h"
#import "RichListMainViewController.h"
#import "NewsMainViewController.h"
#import "ApplicationMainViewController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSArray *specialViewControllerArray;
@end

@implementation BaseNavigationController


- (NSArray *)specialViewControllerArray{
    if(!_specialViewControllerArray){
        _specialViewControllerArray = @[[AssestsMainViewController class], [RichListMainViewController class], [NewsMainViewController class], [ApplicationMainViewController class]];
    }
    return _specialViewControllerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark -
#pragma mark UINavigationController Delegate
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    /**
     *  From the root view push on to the next hid tabBar viewcontroller
     */
    if(self.viewControllers.count > 0 && ![self.specialViewControllerArray containsObject: [viewController class]]){

        [(BaseTabBarController *)self.tabBarController dismissTabBar];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    /**
     *  Remove the last interface image
     */
    if(self.viewControllers.count == 2 ){  // || self.viewControllers.count == 3
        [(BaseTabBarController *)self.tabBarController showTabBar];
    }
    return [super popViewControllerAnimated: animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    /**
     *  Remove the last interface image
     */
    
    if(self.viewControllers.count == 2 || self.viewControllers.count == 3){
        [(BaseTabBarController *)self.tabBarController showTabBar];
    }
    return [super popToRootViewControllerAnimated: animated];
}


#pragma mark - navigation delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    /**
     *  When back to the root view shows the tabbar
     */
    if(self.viewControllers.count == 1 || [self.specialViewControllerArray containsObject: [viewController class]]){
        /**
         *  show tabBar
         */
        //        [UIView animateWithDuration: 0.3f animations:^{
        //            [self.tabBarController.tabBar setTop: SCREEN_HEIGHT - TABBAR_HEIGHT];
        //        }];
        [(BaseTabBarController *)self.tabBarController showTabBar];
    }
    else{
        [(BaseTabBarController *)self.tabBarController dismissTabBar];
    }
}

@end

