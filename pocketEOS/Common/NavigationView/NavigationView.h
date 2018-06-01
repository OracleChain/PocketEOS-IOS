//
//  NavigationView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/5.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"
#import "BaseLabel.h"

@protocol NavigationViewDelegate <NSObject>
@optional
- (void)leftBtnDidClick;
- (void)rightBtnDidClick;
@end

@interface NavigationView : BaseView

@property(nonatomic, weak) id<NavigationViewDelegate> delegate;


@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) BaseLabel *titleLabel;
@property(nonatomic, strong) UIImageView *titleImg;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) UIImageView *rightImg;

/**
 导航栏 (左右的按键均为图片 + 标题文字)
 */
+ (instancetype)navigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName title:(NSString *)title rightBtnImgName:(NSString *)rightImgName delegate:(id<NavigationViewDelegate>)delegate;


/**
 导航栏 (左button为图片 + 标题 + 右 button 为文字)
 */
+ (instancetype)navigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName title:(NSString *)title rightBtnTitleName:(NSString *)rightBtnTitleName delegate:(id<NavigationViewDelegate>)delegate;

/**
 导航栏 (左右的按键均为图片 + 标题为图片)
 */
+ (instancetype)navigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName titleImage:(NSString *)titleImage rightBtnImgName:(NSString *)rightBtnImgName delegate:(id<NavigationViewDelegate>)delegate;


/**
 导航栏 (左右的按键均为图片 + 标题为图片 , 右侧的图片可以改变)
 */
- (instancetype)initNavigationViewWithFrame:(CGRect)frame LeftBtnImgName:(NSString *)leftImgName titleImage:(NSString *)titleImage rightImgName:(NSString *)rightImgName delegate:(id<NavigationViewDelegate>)delegate;
@end


