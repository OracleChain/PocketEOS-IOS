//
//  AskQuestion_abi_to_json_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AskQuestion_abi_to_json_request : BaseHttpsNetworkRequest


/**
 问题id, 传任意整数, 后期提供java接口，获取最佳id值，减少合约本身的运算 写死等于1
 */
//@property(nonatomic, strong) NSNumber *questionID;

/**
 发起问题的人eos账户名
 */
@property(nonatomic, copy) NSString *from;


/**

 */
@property(nonatomic, copy) NSString *quantity;


/**
 =0传0即可 合于会使用最新区块时间now()
 */
//@property(nonatomic, strong) NSNumber *createtime;

/**
 问题截止时间秒数，真的截止时间，合约会自动设置为 endtime=now()+endtime
 */
@property(nonatomic, strong) NSNumber *endtime;


/**
 可选答案个数
 */
@property(nonatomic, strong) NSNumber *optionanswerscnt;

/**
 标题
 */
@property(nonatomic, copy) NSString *asktitle;

/**
 问题答案，为转义的json string
 */
@property(nonatomic, copy) NSString *optionanswers;


@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;

@end
