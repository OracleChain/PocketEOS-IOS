//
//  DappPushMessageModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DappPushMessageModel : UIView
@property(nonatomic , copy) NSString *serialNumber;
@property(nonatomic , copy) NSString *params;
@property(nonatomic , copy) NSString *methodName;
@end
