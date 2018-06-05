//
//  TransferService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "TransferService.h"
#import "RichListResult.h"
#import "Follow.h"
#import "BlockChainInfo.h"
#import "GetBlockChainInfoRequest.h"
#import "Abi_json_to_binRequest.h"
#import "AskQuestion_abi_to_json_request.h"
#import "GetRequiredPublicKeyRequest.h"
#import "PushTransactionRequest.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "TypeChainId.h"
#import "EosByteWriter.h"
#import "EOS_Key_Encode.h"
#import "Sha256.h"
#import "uECC.h"
#import "NSObject+Extension.h"
#import "NSDate+ExFoundation.h"
#import "GetRateResult.h"
#import "Rate.h"
#import "WalletAccountsResult.h"
#import "Wallet.h"
#import "rmd160.h"
#import "libbase58.h"
#import "NSData+Hash.h"


@interface TransferService()

@property(nonatomic, strong) GetBlockChainInfoRequest *getBlockChainInfoRequest;
@property(nonatomic, strong) Abi_json_to_binRequest *abi_json_to_binRequest;
@property(nonatomic , strong) AskQuestion_abi_to_json_request *askQuestion_abi_to_json_request;
@property(nonatomic, strong) GetRequiredPublicKeyRequest *getRequiredPublicKeyRequest;
@property(nonatomic, strong) PushTransactionRequest *pushTransactionRequest;

@property(nonatomic, strong) JSContext *context;
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, copy) NSString *ref_block_num;
@property(nonatomic , strong) NSData *chain_Id;
@property(nonatomic, copy) NSString *expiration;
@property(nonatomic, copy) NSString *required_Publickey;


@end


@implementation TransferService
- (RichListRequest *)richListRequest{
    if (!_richListRequest) {
        _richListRequest = [[RichListRequest alloc] init];
    }
    return _richListRequest;
}

- (GetBlockChainInfoRequest *)getBlockChainInfoRequest{
    if (!_getBlockChainInfoRequest) {
        _getBlockChainInfoRequest = [[GetBlockChainInfoRequest alloc] init];
    }
    return _getBlockChainInfoRequest;
}

- (Abi_json_to_binRequest *)abi_json_to_binRequest{
    if (!_abi_json_to_binRequest) {
        _abi_json_to_binRequest = [[Abi_json_to_binRequest alloc] init];
    }
    return _abi_json_to_binRequest;
}

- (AskQuestion_abi_to_json_request *)askQuestion_abi_to_json_request{
    if (!_askQuestion_abi_to_json_request) {
        _askQuestion_abi_to_json_request = [[AskQuestion_abi_to_json_request alloc] init];
    }
    return _askQuestion_abi_to_json_request;
}

- (GetRequiredPublicKeyRequest *)getRequiredPublicKeyRequest{
    if (!_getRequiredPublicKeyRequest) {
        _getRequiredPublicKeyRequest = [[GetRequiredPublicKeyRequest alloc] init];
    }
    return _getRequiredPublicKeyRequest;
}

- (PushTransactionRequest *)pushTransactionRequest{
    if (!_pushTransactionRequest) {
        _pushTransactionRequest = [[PushTransactionRequest alloc] init];
    }
    return _pushTransactionRequest;
}

- (GetRateRequest *)getRateRequest{
    if (!_getRateRequest) {
        _getRateRequest = [[GetRateRequest alloc] init];
    }
    return _getRateRequest;
}

- (NSMutableArray *)richListDataArray{
    if (!_richListDataArray) {
        _richListDataArray = [[NSMutableArray alloc] init];
    }
    return _richListDataArray;
}

- (JSContext *)context{
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}


// pushTransaction
- (void)pushTransaction{
    [self getBlockChainInfoOperation];
}

- (void)getBlockChainInfoOperation{
    WS(weakSelf);
    [self.getBlockChainInfoRequest getDataSusscess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
#pragma mark -- [@"data"]
            BlockChainInfo *model = [BlockChainInfo mj_objectWithKeyValues:data[@"data"]];// [@"data"]
            weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
            weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
            
            NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
            [weakSelf.context evaluateScript:js];
            JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8, model.head_block_id, @8]];
            weakSelf.ref_block_prefix = [n toString];
            
            weakSelf.chain_Id = [NSObject convertHexStrToData:model.chain_id];
            NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
            
            [weakSelf getRequiredPublicKeyRequestOperation];
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"error:%@", error);
    }];
}


- (void)getRequiredPublicKeyRequestOperation{
    self.getRequiredPublicKeyRequest.ref_block_prefix = self.ref_block_prefix;
    self.getRequiredPublicKeyRequest.ref_block_num = self.ref_block_num;
    self.getRequiredPublicKeyRequest.expiration = self.expiration;
    self.getRequiredPublicKeyRequest.sender = self.sender;
    self.getRequiredPublicKeyRequest.data = self.binargs;
    self.getRequiredPublicKeyRequest.account = self.code;
    self.getRequiredPublicKeyRequest.name = self.action;
    self.getRequiredPublicKeyRequest.available_keys = self.available_keys;
    
    
    WS(weakSelf);
    self.getRequiredPublicKeyRequest.showActivityIndicator = YES;
    [self.getRequiredPublicKeyRequest postOuterDataSuccess:^(id DAO, id data) {
        #pragma mark -- [@"data"]
        if ([data[@"code"] isEqualToNumber:@0 ]) {
            weakSelf.required_Publickey = data[@"data"][@"required_keys"][0];
            NSLog(@"get_required_keys_success: -- %@",data[@"data"][@"required_keys"][0]);//
            [weakSelf pushTransactionRequestOperation];
            
        }else{
            [TOASTVIEW showWithText: VALIDATE_STRING(data[@"message"])];
        }
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"get_required_keys_error: -- %@",error);
    }];
}

- (void)pushTransactionRequestOperation{
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.sender];
    NSString *wif;
    if ([accountInfo.account_owner_public_key isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accountInfo.account_owner_private_key password:self.password];
    }else if ([accountInfo.account_active_public_key isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accountInfo.account_active_private_key password:self.password];
    }else{
        [TOASTVIEW showWithText:@"未找到账号的私钥!"];
        return;
    }
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TOASTVIEW showWithText:@"private_key can't be nil!"];
        return;
    }
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignature:self.chain_Id andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:255]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        NSString *signatureStr = [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
        NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
        
        self.pushTransactionRequest.packed_trx = packed_trxHexStr;
        self.pushTransactionRequest.signatureStr = signatureStr;
        WS(weakSelf);
        self.pushTransactionRequest.showActivityIndicator = YES;
        NSLog(@"%@", [[self.pushTransactionRequest parameters] mj_JSONObject]);
        
        [self.pushTransactionRequest postOuterDataSuccess:^(id DAO, id data) {
            NSLog(@"success: -- %@",data );
            
            TransactionResult *result = [TransactionResult mj_objectWithKeyValues:data];
            
            if (weakSelf.pushTransactionType == PushTransactionTypeTransfer) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pushTransactionDidFinish:)]) {
                    [weakSelf.delegate pushTransactionDidFinish:result];
                }
                
            }else if (weakSelf.pushTransactionType == PushTransactionTypeApprove){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(approveDidFinish:)]) {
                    [weakSelf.delegate approveDidFinish:result];
                }
                
            }else if (weakSelf.pushTransactionType == PushTransactionTypeAskQustion){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(askQuestionDidFinish:)]) {
                    [weakSelf.delegate askQuestionDidFinish:result];
                }
                
            }else if (weakSelf.pushTransactionType == PushTransactionTypeAnswer){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(answerQuestionDidFinish:)]) {
                    [weakSelf.delegate answerQuestionDidFinish:result];
                }
                
            }
        } failure:^(id DAO, NSError *error) {
            NSLog(@"responseERROR:%@", [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:nil]);
        }];
    }
}


/**
 get_rate
 */
- (void)get_rate:(CompleteBlock)complete{
    [self.getRateRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            GetRateResult *result = [GetRateResult mj_objectWithKeyValues:data];
            complete(result , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}



- (void)getRichlistAccount:(CompleteBlock)complete{
    WS(weakSelf);
    [self.richListRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.richListDataArray removeAllObjects];
        RichListResult *result = [RichListResult mj_objectWithKeyValues:data];
        // 关注的账号或钱包
        NSMutableArray *followsArr = result.data;
        // 获取 key 对应的数据源
        NSMutableArray *itemArray = [NSMutableArray array];
        for (Follow *model in followsArr) {
            if ([model.followType isEqualToNumber:@2]) {
                [weakSelf.richListDataArray addObject:model];
            }
        }
        complete(weakSelf , YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}
@end

