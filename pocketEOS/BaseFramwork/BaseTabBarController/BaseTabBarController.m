//
//  BaseTabBarController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "AssestsMainViewController.h"
#import "RichListMainViewController.h"
#import "NewsMainViewController.h"
#import "ApplicationMainViewController.h"
#import "UITabBar+CustomBadge.h"
#import "XYTabBar.h"

@interface BaseTabBarController()<UITabBarControllerDelegate>
@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC
@end


@implementation BaseTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}


#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[XYTabBar new] forKey:@"tabBar"];
    self.tabBar.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    [self.tabBar setBackgroundImage:[UIImage new]];
    
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.tabBar setBackgroundImage:img];
    
    [self.tabBar setShadowImage:img];
    
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        // Create a new layer which is the width of the device and with a heigh
        // of 0.5px.
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.5f);
        
        // Set the background colour of the new layer to the colour you wish to
        // use for the border.
        topBorder.backgroundColor = [HEXCOLOR(0xEEEEEE) CGColor];
        
        
        // Add the later to the tab bar's existing layer
        [self.tabBar.layer addSublayer:topBorder];
        //通过这两个参数来调整badge位置
        //    [self.tabBar setTabIconWidth:29];
        //    [self.tabBar setBadgeTop:9];
        
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        [self.tabBar setBackgroundImage:img];
        
        [self.tabBar setShadowImage:img];
        
    }
}


#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    
    AssestsMainViewController *assestsMainVC = [[AssestsMainViewController alloc]init];
    [self setupChildViewController:assestsMainVC title: NSLocalizedString(@"资产", nil)imageName:@"assest_unSelect" seleceImageName:@"assest_select" BB_imageName:@"assest_unSelect_BB" BB_seleceImageName:@"assest_Select_BB"];
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {

        RichListMainViewController *richListVC = [[RichListMainViewController alloc]init];
        [self setupChildViewController:richListVC title:NSLocalizedString(@"富豪榜", nil)imageName:@"richList_unSelect" seleceImageName:@"richList_select" BB_imageName:@"" BB_seleceImageName:@""];

    }
    
    
    NewsMainViewController *newsVC = [NewsMainViewController new];
    [self setupChildViewController:newsVC title:NSLocalizedString(@"新闻", nil) imageName:@"news_unSelect" seleceImageName:@"news_select" BB_imageName:@"news_unSelect_BB" BB_seleceImageName:@"news_select_BB"];
    

//    ApplicationMainViewController *dappVC = [[ApplicationMainViewController alloc]init];
//    [self setupChildViewController:dappVC title:NSLocalizedString(@"发现", nil)imageName:@"application_unSelect" seleceImageName:@"application_select" BB_imageName:@"application_unSelect_BB" BB_seleceImageName:@"application_select_BB"];

    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName BB_imageName:(NSString *)BB_imageName BB_seleceImageName:(NSString *)BB_selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 普通状态下的文字属性
        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:9];
        normalAttrs[NSForegroundColorAttributeName] = HEXCOLOR(0xC5CAD4);
        [controller.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        
        // 选中状态下的文字属性
        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
        selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:9];
        selectedAttrs[NSForegroundColorAttributeName] = HEXCOLOR(0x2A2A2A);
        [controller.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        
    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        controller.tabBarItem.image = [[UIImage imageNamed:BB_imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.tabBarItem.selectedImage = [[UIImage imageNamed:BB_selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 普通状态下的文字属性
        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:9];
        normalAttrs[NSForegroundColorAttributeName] = HEXCOLOR(0x5C5D65);
        [controller.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        
        // 选中状态下的文字属性
        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
        selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:9];
        selectedAttrs[NSForegroundColorAttributeName] = HEXCOLOR(0xFFFFFF);
        [controller.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    }
    
    
    
    
    //包装导航控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:controller];
    [_VCS addObject:nav];
    
}


#pragma mark - public methods
#pragma mark 显示TabBar
- (void)showTabBar{
    [self.tabBar setHidden:NO];
}

#pragma mark 隐藏TabBar
- (void)dismissTabBar{
    [self.tabBar setHidden:YES];
}
@end
