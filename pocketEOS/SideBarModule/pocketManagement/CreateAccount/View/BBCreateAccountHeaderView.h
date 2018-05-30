//
//  BBCreateAccountHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBCreateAccountHeaderViewDelegate<NSObject>
- (void)createAccountUseEOSPrivateKey;
@end


@interface BBCreateAccountHeaderView : UIView
@property(nonatomic, weak) id<BBCreateAccountHeaderViewDelegate> delegate;

@end
