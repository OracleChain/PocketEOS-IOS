//
//  PopUpAssestWindow.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpAssestWindowDelegate<NSObject>
- (void )popUpAssestWindowdidSelectItem:(id)sender;

@end

// 弹出的资产选择框
@interface PopUpAssestWindow : UIView

@property(nonatomic, weak) id<PopUpAssestWindowDelegate> delegate;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, copy) void (^onBottomViewDidClick)(void);



- (void)updateViewWithArray:(NSArray *)arr title:(NSString *)title;

@end
