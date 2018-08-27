//
//  ForwardRedPacketViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2017/12/6.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"
#import "GetRateResult.h"
#import "Rate.h"

@interface ForwardRedPacketViewController : BaseViewController
@property(nonatomic , strong) RedPacketModel *redPacketModel;
@property(nonatomic, strong) GetRateResult *getRateResult;
@end
