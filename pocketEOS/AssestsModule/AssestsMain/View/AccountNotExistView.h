//
//  AccountNotExistView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountNotExistViewDelegate<NSObject>
- (void)checkAccountStatusBtnDidClick;
- (void)contactUsLabelDidTap;
@end


@interface AccountNotExistView : UIView

@property(nonatomic, weak) id<AccountNotExistViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
