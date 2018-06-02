//
//  PopUpWindow.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/4.
//  Copyright © 2017年 oraclechain. All rights reserved.
//
typedef NS_ENUM(NSUInteger, PopUpWindowType) {
    PopUpWindowTypeAccount,
    PopUpWindowTypeAssest
};

#import <UIKit/UIKit.h>


@protocol PopUpWindowDelegate<NSObject>
- (void )popUpWindowdidSelectItem:(id)sender;

@end

@interface PopUpWindow : UIView


@property(nonatomic, weak) id<PopUpWindowDelegate> delegate;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, copy) void (^onBottomViewDidClick)(void);

//  model为assests还是 accounts
@property(nonatomic, assign) PopUpWindowType type;

- (void)updateViewWithArray:(NSArray *)arr title:(NSString *)title;

@end
