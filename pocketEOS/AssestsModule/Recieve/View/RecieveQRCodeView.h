//
//  RecieveQRCodeView.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/7.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecieveQRCodeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *assestTypeLabel;

/**
 收款二维码
 */
@property (weak, nonatomic) IBOutlet UIImageView *recieveAssestsQRCodeImg;

@end
