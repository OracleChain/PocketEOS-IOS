//
//  ExcuteMultipleActionsService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//


#import "ExcuteMultipleActionsService.h"
#import "BlockChainInfo.h"
#import "GetBlockChainInfoRequest.h"
#import "Abi_json_to_binRequest.h"
#import "ExcuteMutipleActionsGetRequiredPublicKeyRequest.h"
#import "PushTransactionRequest.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "TypeChainId.h"
#import "EosByteWriter.h"
#import "EOS_Key_Encode.h"
#import "Sha256.h"
#import "uECC.h"
#import "NSObject+Extension.h"
#import "NSDate+ExFoundation.h"
#import "rmd160.h"
#import "libbase58.h"
#import "NSData+Hash.h"
#import "Abi_json_to_bin_Result.h"
#import "Abi_json_to_bin.h"
#import "ScatterAction.h"



@interface ExcuteMultipleActionsService()
@property(nonatomic , copy) NSString *sender;
@property(nonatomic , strong) NSArray *excuteActionsArray;
@property(nonatomic , strong) NSMutableArray *finalExcuteActionsArray; // excuteActions add binargs Array
@property(nonatomic , strong) NSArray *available_keys;
@property(nonatomic , copy) NSString *password;

@property(nonatomic, strong) GetBlockChainInfoRequest *getBlockChainInfoRequest;
@property(nonatomic, strong) Abi_json_to_binRequest *abi_json_to_binRequest;
@property(nonatomic, strong) ExcuteMutipleActionsGetRequiredPublicKeyRequest *getRequiredPublicKeyRequest;
@property(nonatomic, strong) PushTransactionRequest *pushTransactionRequest;

@property(nonatomic, strong) JSContext *context;
@property(nonatomic, copy) NSString *ref_block_prefix;

@property(nonatomic , strong) NSData *chain_Id;
@property(nonatomic, copy) NSString *expiration;
@property(nonatomic, copy) NSString *required_Publickey;
@property(nonatomic , assign) NSInteger abi_json_to_bin_request_count;
@property(nonatomic , strong) id data;
@end


@implementation ExcuteMultipleActionsService

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

- (ExcuteMutipleActionsGetRequiredPublicKeyRequest *)getRequiredPublicKeyRequest{
    if (!_getRequiredPublicKeyRequest) {
        _getRequiredPublicKeyRequest = [[ExcuteMutipleActionsGetRequiredPublicKeyRequest alloc] init];
    }
    return _getRequiredPublicKeyRequest;
}

- (PushTransactionRequest *)pushTransactionRequest{
    if (!_pushTransactionRequest) {
        _pushTransactionRequest = [[PushTransactionRequest alloc] init];
    }
    return _pushTransactionRequest;
}

- (JSContext *)context{
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}


// excuteMultipleActions
- (void)excuteMultipleActionsWithSender:(NSString *)sender andExcuteActionsArray:(NSArray <ExcuteActions *>*)excuteActionsArray andAvailable_keysArray:(NSArray *)available_keysArray andPassword:(NSString *)password{
    self.sender = sender;
    self.excuteActionsArray = excuteActionsArray;
    self.available_keys = available_keysArray;
    self.password = password;
    [self getBlockChainInfoOperation];
}

- (void)getBlockChainInfoOperation{
    WS(weakSelf);
    [SVProgressHUD showWithStatus:nil];
    [self.getBlockChainInfoRequest getDataSusscess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
#pragma mark -- [@"data"]
            BlockChainInfo *model = [BlockChainInfo mj_objectWithKeyValues:data[@"data"]];// [@"data"]
            weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
            self.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
            weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
            
            NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
            [weakSelf.context evaluateScript:js];
            JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
            
            weakSelf.ref_block_prefix = [n toString];
            
            weakSelf.chain_Id = [NSObject convertHexStrToData:model.chain_id];
            NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
            
            [weakSelf abiJsonToBinRequestOperation];
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

- (void)abiJsonToBinRequestOperation{
    WS(weakSelf);
    self.finalExcuteActionsArray = [NSMutableArray array];
    self.abi_json_to_bin_request_count = 0;
    NSMutableArray *tmp = [NSMutableArray array];
    for (int i = 0 ; i < self.excuteActionsArray.count; i++) {
        ExcuteActions *action = self.excuteActionsArray[i];
        action.tag = [NSString stringWithFormat:@"action%d", i];
        
        self.abi_json_to_binRequest.code = action.account;
        self.abi_json_to_binRequest.action = action.name;
        self.abi_json_to_binRequest.args = [action.data mj_JSONObject];
        
        AFHTTPSessionManager *outerNetworkingManager = [[AFHTTPSessionManager alloc] init];
        [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Accept"];
        [outerNetworkingManager.requestSerializer setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
        outerNetworkingManager.requestSerializer=[AFJSONRequestSerializer serializer];
        [outerNetworkingManager.requestSerializer setValue: action.tag forHTTPHeaderField: @"From"];
        
        [outerNetworkingManager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/plain",@"text/json", @"text/javascript", nil]];
        [SVProgressHUD showWithStatus:nil];


        NSString *url = [NSString stringWithFormat:@"%@/api_oc_blockchain-v1.3.0/abi_json_to_bin", REQUEST_HTTP_BASEURL];


        NSLog(@"abi_json_to_binRequest url%@", url);
        NSLog(@"abi_json_to_binRequest param%@", [[self.abi_json_to_binRequest parameters] mj_JSONString]);
        [outerNetworkingManager POST: url parameters: [self.abi_json_to_binRequest parameters] progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *HTTPHeaderFieldFromValue = [outerNetworkingManager.requestSerializer valueForHTTPHeaderField:@"From"];
            NSLog(@"abi_json_to_binRequest_success: %@,HTTPHeaderFieldFromValue: %@", responseObject, HTTPHeaderFieldFromValue);
            Abi_json_to_bin_Result *abi_json_to_bin_result = [Abi_json_to_bin_Result mj_objectWithKeyValues:responseObject];
           
            if ([abi_json_to_bin_result.code isEqualToNumber:@0]) {
                if ([HTTPHeaderFieldFromValue isEqualToString:action.tag]) {
                    action.binargs = abi_json_to_bin_result.data.binargs;
                    weakSelf.abi_json_to_bin_request_count ++;
                    [tmp addObject:action];
                    
                    if (weakSelf.abi_json_to_bin_request_count == self.excuteActionsArray.count) {
                        weakSelf.finalExcuteActionsArray =  (NSMutableArray *)[tmp sortedArrayUsingComparator:^NSComparisonResult(ExcuteActions  *obj1, ExcuteActions *obj2) {
                            return [obj1.tag compare:obj2.tag options:(NSCaseInsensitiveSearch)];
                        }];
                        [weakSelf getRequiredPublicKeyRequestOperation];
                    }
                }
            }else{
                [TOASTVIEW showWithText:abi_json_to_bin_result.message];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }
    
}


- (void)getRequiredPublicKeyRequestOperation{
    self.getRequiredPublicKeyRequest.ref_block_prefix = self.ref_block_prefix;
    self.getRequiredPublicKeyRequest.ref_block_num = self.ref_block_num;
    self.getRequiredPublicKeyRequest.expiration = self.expiration;
    self.getRequiredPublicKeyRequest.sender = self.sender;
    self.getRequiredPublicKeyRequest.excuteActionsArray = self.finalExcuteActionsArray;
    self.getRequiredPublicKeyRequest.available_keys = self.available_keys;
    
    WS(weakSelf);
    self.getRequiredPublicKeyRequest.showActivityIndicator = YES;
    [SVProgressHUD showWithStatus:nil];
    [self.getRequiredPublicKeyRequest postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        if ([data[@"code"] isEqualToNumber:@0 ]) {
            self.required_Publickey = data[@"data"][@"required_keys"][0];
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
        [TOASTVIEW showWithText:NSLocalizedString(@"未找到账号的私钥!", nil)];
        return;
    }
    NSLog(@"xpetwif:%@",wif );
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TOASTVIEW showWithText:@"private_key can't be nil!"];
        return;
    }
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignatureExcuteMultipleActions:self.chain_Id andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:255]];
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
        NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignatureExcuteMultipleActions:nil andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
        
        self.pushTransactionRequest.packed_trx = packed_trxHexStr;
        self.pushTransactionRequest.signatureStr = signatureStr;
        WS(weakSelf);
        self.pushTransactionRequest.showActivityIndicator = YES;
        NSLog(@"%@", [[self.pushTransactionRequest parameters] mj_JSONObject]);
        [SVProgressHUD showWithStatus:nil];
        [self.pushTransactionRequest postOuterDataSuccess:^(id DAO, id data) {
            NSLog(@"pushTransactionRequestSuccess: -- %@",data );
            self.data = data;
            TransactionResult *result = [TransactionResult mj_objectWithKeyValues:data];
            result.tag = weakSelf.tag;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(excuteMultipleActionsDidFinish:)]) {
                [weakSelf.delegate excuteMultipleActionsDidFinish:result];
            }
        } failure:^(id DAO, NSError *error) {
            NSLog(@"responseERROR:%@", [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:nil]);
        }];
    }
}


// excuteMultipleActions -- For Scatter-JS
- (NSString *)excuteMultipleActionsForScatterWithScatterResult:(ScatterResult_type_requestSignature *)scatterResult andAvailable_keysArray:(NSArray *)available_keysArray andPassword:(NSString *)password{
    
    self.sender = scatterResult.actor;
    self.excuteActionsArray = (NSMutableArray *)scatterResult.actions;
    self.available_keys = available_keysArray;
    self.password = password;
    self.required_Publickey = available_keysArray[0];
    
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.sender];
    NSString *wif = [AESCrypt decrypt:accountInfo.account_active_private_key password:self.password];
//    if ([accountInfo.account_owner_public_key isEqualToString:self.required_Publickey]) {
//        wif = [AESCrypt decrypt:accountInfo.account_owner_private_key password:self.password];
//    }else if ([accountInfo.account_active_public_key isEqualToString:self.required_Publickey]) {
//        wif = [AESCrypt decrypt:accountInfo.account_active_private_key password:self.password];
//    }else{
//        [TOASTVIEW showWithText:NSLocalizedString(@"未找到账号的私钥!", nil)];
//        return nil;
//    }
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TOASTVIEW showWithText:@"private_key can't be nil!"];
        return nil;
    }
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(scatterResult.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(scatterResult.ref_block_num) forKey:@"ref_block_num"];
    
    [transacDic setObject:VALIDATE_STRING(scatterResult.expiration) forKey:@"expiration"];
    
    NSMutableArray *actionsArr = [NSMutableArray array];
    for (int i = 0 ; i < self.excuteActionsArray.count; i++) {
        NSDictionary *dict = self.excuteActionsArray[i];
        ScatterAction *action = [ScatterAction mj_objectWithKeyValues:dict];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
        [actionDict setObject:VALIDATE_STRING(action.account) forKey:@"account"];
        [actionDict setObject:VALIDATE_STRING(action.name) forKey:@"name"];
        [actionDict setObject:VALIDATE_STRING(action.data) forKey:@"data"];
        [actionDict setObject:VALIDATE_ARRAY(action.authorization) forKey:@"authorization"];
        [actionsArr addObject:actionDict];
    }
    
    [transacDic setObject:VALIDATE_ARRAY(actionsArr) forKey:@"actions"];
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignatureExcuteMultipleActions:[NSObject convertHexStrToData:@"aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906"] andParams: transacDic andCapacity:255]]; // chainId 写死
//    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignatureExcuteMultipleActions:[NSObject convertHexStrToData:scatterResult.chainId] andParams: transacDic andCapacity:255]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
        return nil;
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
        return signatureStr;
    }
    
}


- (NSString *)excuteSignatureMessageForScatterWithActor:(NSString *)actor signatureMessage:(NSString *)messageStr andPassword:(NSString *)password{
    
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:actor];
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:[AESCrypt decrypt:accountInfo.account_active_private_key password:password]] bytes];
//    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:@"5JLHReCKAn88SdEDtDt8DzMweDdD7eiaoc6w72jWFuVR4piNh5y"] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TOASTVIEW showWithText:@"private_key can't be nil!"];
        return nil;
    }
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[messageStr dataUsingEncoding:NSUTF8StringEncoding]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
        return nil;
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
        NSLog(@"signatureStr %@", signatureStr);
        return signatureStr;
    }
    
}



@end

