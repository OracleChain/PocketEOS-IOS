//
//  NotifyDappServerResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/9/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>


// 用户完成操作后，钱包回调URL,如https://abc.com?action=login&qrcID=123，可选
// 钱包回调时在此URL后加上操作结果(result、txID、serialNumber)，如：https://abc.com?action=login&qrcID=123&result=1&txID=xxx&serialNumber=xxx,
// result的值为：0为用户取消，1为成功,  2为失败；txID为EOS主网上该笔交易的id（若有）

@interface NotifyDappServerResult : NSObject

@property(nonatomic , copy) NSString *result;

@property(nonatomic , copy) NSString *txID;

@property(nonatomic , copy) NSString *serialNumber;

@property(nonatomic , copy) NSString *callback;

@end
