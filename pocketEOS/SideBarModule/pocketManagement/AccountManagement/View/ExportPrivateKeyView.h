//
//  ExportPrivateKeyView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExportPrivateKeyViewDelegate<NSObject>
- (void)genetateQRBtnDidClick:(UIButton *)sender;
- (void)copyBtnDidClick:(UIButton *)sender;
@end

@interface ExportPrivateKeyView : UIView
@property (weak, nonatomic) IBOutlet UILabel *privateKeyLabel;
@property(nonatomic, weak) id<ExportPrivateKeyViewDelegate> delegate;
@property(nonatomic, strong) UIImageView *QRCodeimg;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@end
