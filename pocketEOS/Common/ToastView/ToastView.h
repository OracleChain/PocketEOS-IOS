//
//  ToastView.h
//  Giivv
//
//  Created by Xiong, Zijun on 16/4/9.
//  Copyright © 2016 Youdar. All rights reserved.
//

#define TOASTVIEW [ToastView shareManager]
#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property(nonatomic, strong) void(^onButtonClick)(NSInteger index);

/**
 *  public method
 */
+(ToastView *)shareManager;
- (void)showWithText:(NSString *) text;
- (void)showWithText:(NSString *) text duration:(CGFloat) duration;
- (void)showAlertText:(NSString *) text;
- (void)showAlertText:(NSString *) text withTitle: (NSString *)title;

- (void)dismiss;

- (void)showCustomerAlertText:(NSString *) text withTitle: (NSString *)title;

- (void)showCustomerAlertText:(NSString *) text withTitle: (NSString *)title cancelButton:(UIButton *) customerCancelButton Button:(UIButton *) button;
@end
