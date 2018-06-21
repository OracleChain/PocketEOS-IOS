//  
//  AppDelegate.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "LoginMainViewController.h"
#import "BBLoginViewController.h"
#import "WXApi.h"
#import "SocialManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "LEEBubble.h"

@interface AppDelegate ()<WXApiDelegate, QQApiInterfaceDelegate>

@end

@implementation AppDelegate


void uncaughtExceptionHandler(NSException*exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // 设置主题
    [self configTheme];
    
    
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    BaseTabBarController *rootVC = [[BaseTabBarController alloc] init];
    [self.window setRootViewController: rootVC];
    // 初始化气泡
//    [self configLEEBubble];
    
    
    [[SocialManager socialManager] initWithSocialSDK:application didFinishLaunchingWithOptions:launchOptions];
    
    Wallet *wallet = CURRENT_WALLET;
    NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
    if (accountArray.count > 0) {
        
        [self.window setRootViewController: rootVC];
        
        // 如果本地有当前账号对应的钱包且有账号
    }else{
        if (wallet) {
            [[WalletTableManager walletTable] deleteRecord:wallet.wallet_uid];            
        }
        UIViewController *vc;
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            vc = [[LoginMainViewController alloc] init];
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            vc = [[BBLoginViewController alloc] init];
        }
        
        // 如果本地没有当前账号对应的钱包
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.window setRootViewController: navi];
    }
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    return YES;
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([SocialManager socialManager].socialType == kWechat) {
        return [WXApi handleOpenURL:url delegate:[SocialManager socialManager]];
    }else if ([SocialManager socialManager].socialType == kQQ){
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    if ([SocialManager socialManager].socialType == kWechat) {
         return [WXApi handleOpenURL:url delegate:[SocialManager socialManager]];
    }else if ([SocialManager socialManager].socialType == kQQ){
        [QQApiInterface handleOpenURL:url delegate:[SocialManager socialManager]];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

#pragma mark - 设置主题

- (void)configTheme{
    
    NSString *socialModeJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_SocialMode" ofType:@"json"];
    
    NSString *blackBoxModeJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_BlackBoxMode" ofType:@"json"];
    
    NSString *socialModeJson = [NSString stringWithContentsOfFile:socialModeJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *blackBoxModeJson = [NSString stringWithContentsOfFile:blackBoxModeJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    if (IsStrEmpty([LEETheme currentThemeTag])) {
        [LEETheme defaultTheme:SOCIAL_MODE];
    }
    
    //    [LEETheme defaultChangeThemeAnimationDuration:0.0f];
    
    [LEETheme addThemeConfigWithJson:socialModeJson Tag:SOCIAL_MODE ResourcesPath:nil];
    
    [LEETheme addThemeConfigWithJson:blackBoxModeJson Tag:BLACKBOX_MODE ResourcesPath:nil];

}

- (void)configLEEBubble{
    LEEBubble *bubble = [[LEEBubble alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.window.frame) - 58, CGRectGetHeight(self.window.frame) - 123, 48, 48)];
    
    bubble.edgeInsets = UIEdgeInsetsMake(64, 0 , 0 , 0);
    
    [self.window addSubview:bubble];
    
    bubble.lee_theme
    .LeeAddSelectorAndColor(SOCIAL_MODE, @selector(setColor:), [UIColor grayColor])
    .LeeAddSelectorAndColor(BLACKBOX_MODE, @selector(setColor:), [UIColor grayColor])
    .LeeConfigSelectorAndIdentifier(@selector(setColor:), @"ident1")
    .LeeThemeChangingBlock(^(NSString *tag, LEEBubble * item) {
        
        if ([tag isEqualToString:SOCIAL_MODE]) {
            
            item.image = [UIImage imageNamed:@"day"];
            
        } else if ([tag isEqualToString:BLACKBOX_MODE]) {
            
            item.image = [UIImage imageNamed:@"night"];
            
        } else {
            
            item.image = [UIImage imageNamed:@"night"];
        }
        
    });
    
    __weak typeof(self) weakSelf = self;
    
    bubble.clickBubbleBlock = ^(){
        
        if (weakSelf){
            
            /*  这是一种巧妙的方法 良好的过渡效果可以很好地提高体验 可以根据你的使用场景来进行尝试
             
             关于文字颜色改变时增加过渡的动画效果这点很不好处理, 如果增加动画处理 那么最终导致切换主题时文字颜色与其他颜色或图片不能很好地统一过渡, 效果上总会有些不自然.
             原理: 切换主题前 获取当前window的快照视图 并覆盖到window上 > 执行主题切换 > 将覆盖的快照视图通过动画隐藏 显示出切换完成的真实window.
             场景: 比较适用于阅读类APP切换日夜间主题场景.
             优点: 过渡效果自然统一, 可根据自行调整不同的动画效果等.
             缺点: 如果当前显示的内容不处于静止状态 那么会产生一种残影的感觉, 例如 列表滑动时切换
             总结: 可以根据你的使用场景来进行尝试, 一切只为了更好的体验 但也无需强求.
             */
            
            // 覆盖截图
            
            UIView *tempView = [weakSelf.window snapshotViewAfterScreenUpdates:NO];
            
            [weakSelf.window addSubview:tempView];
            
            // 切换主题
            
            if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
                
                [LEETheme startTheme:BLACKBOX_MODE];
                
            } else {
                
                [LEETheme startTheme:SOCIAL_MODE];
            }
            
            // 增加动画 移除覆盖
            
            [UIView animateWithDuration:1.0f animations:^{
                
                tempView.alpha = 0.0f;
                
            } completion:^(BOOL finished) {
                
                [tempView removeFromSuperview];
            }];
            
        }
        
    };
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}
@end
