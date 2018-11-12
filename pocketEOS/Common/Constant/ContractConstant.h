//
//  ContractConstant.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/26.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#ifndef ContractConstant_h
#define ContractConstant_h



/**
 SymbolName
 */
#define SymbolName_EOS @"EOS"
#define SymbolName_OCT @"OCT"
#define SymbolName_CET @"CET"

/**
 SmartContractName
 */
#define ContractName_EOSIOTOKEN @"eosio.token"
#define ContractName_EOSIO @"eosio"
#define ContractName_OCTOTHEMOON @"octtothemoon"
#define ContractName_HELLOWORLDGO @"helloworldgo"
#define ContractName_OCASKANS @"ocaskans"
#define ContractName_EOSIOCHAINCE @"eosiochaince"


/**
 SmartContractAction
 */
#define ContractAction_TRANSFER @"transfer"
#define ContractAction_UNDELEGATEBW @"undelegatebw"
#define ContractAction_DELEGATEBW @"delegatebw"
#define ContractAction_VOTEPRODUCER @"voteproducer"
#define ContractAction_BUYRAM @"buyram"
#define ContractAction_SELLRAM @"sellram"
#define ContractAction_APPROVE @"approve"
#define ContractAction_ASK @"ask"
#define ContractAction_ANSWER @"answer"

//投票前需要将自己注册到投票系统
#define ContractAction_REGPROXY @"regproxy"


#define RedPacketReciever @"eosredpacket"
#define RedPacketSpecialAccount_EOSIO @"eosio"


#endif /* ContractConstant_h */
