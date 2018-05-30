//
//  SocialManager.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/27.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

typedef enum {
    kWechat=1,
    kQQ
}SocialType;

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "SocialModel.h"
#import "ShareModel.h"

@interface SocialManager : NSObject<WXApiDelegate,  TencentSessionDelegate, QQApiInterfaceDelegate>

+ (SocialManager *)socialManager;

/**
 *  initialization socail sdk
 *
 *  @param application   current appliction
 *  @param launchOptions  application's launchOptions
 */
- (void)initWithSocialSDK:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@property(nonatomic, assign) SocialType socialType;


// wechat
@property(nonatomic, copy) void(^onWechatLoginSuccess)(SocialModel *model);
- (void)wechatLoginRequest;
- (void)wechatShareToScene:(int)scene withShareModel:(ShareModel *)model;
/**WXImageObject
 scene:: WXScene {
 WXSceneSession  = 0,  聊天界面
 WXSceneTimeline = 1,   朋友圈
 WXSceneFavorite = 2,    收藏
 */
- (void)wechatShareImageToScene:(int)scene withImage:(UIImage *)image;

// qq
@property(nonatomic, strong) TencentOAuth *tencentOAuth;
@property(nonatomic, copy) void(^onQQLoginSuccess)(SocialModel *model);
- (void)qqLoginRequest;
- (void)qqShareToScene:(int)scene withShareModel:(ShareModel *)model;
- (void)qqShareToScene:(int)scene withShareImage:(UIImage *)image;
@end
