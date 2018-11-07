//
//  BaseHttpsNetworkRequest.m
//  pocketEOS
//
//  Created by oraclechain on 16/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#define kHttpsClientP12 @"client"
#define kHttpsP12Password @"oraclechain"
#define kHttpsServiceCer @"server"

#import "BaseHttpsNetworkRequest.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

// release 环境
#define REQUEST_BASEURL @"https://api.pocketeos.top"

// 生产环境
//#define REQUEST_BASEURL @"http://47.105.50.198"

// 测试环境
//#define REQUEST_BASEURL @"http://59.110.162.106:8080"

// 测试环境/lian
//#define REQUEST_BASEURL @"http://192.168.3.205:8888"

// tmp interface
//#define REQUEST_APIPATH [NSString stringWithFormat: @"/lottery%@", [self requestUrlPath]]

// java interface
#define REQUEST_APIPATH [NSString stringWithFormat: @"/api_oc_blockchain-v1.3.0%@", [self requestUrlPath]]

// nakedAddress
//#define REQUEST_APIPATH [NSString stringWithFormat: @"/v1/chain%@", [self requestUrlPath]]

@interface BaseHttpsNetworkRequest()

/**
 *  Response error code
 */
@property(nonatomic, strong) NSDictionary *responseErrorCodeDictionary;
@end



@implementation BaseHttpsNetworkRequest

#pragma mark getters and setters


- (AFHTTPSessionManager *)networkingManager{
    if(!_networkingManager){
        _networkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: REQUEST_BASEURL]];
        _networkingManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    }
    return _networkingManager;
}

- (NSDictionary *)responseErrorCodeDictionary{
    if(!_responseErrorCodeDictionary){
        //        _responseErrorCodeDictionary = @{@101: @"Illegal arguments", @102: @"resource not found", @999: @"internal error", @901: @"JWT Token is expired", @902: @"JWT Token cannot be resolved or auth failed", @110: @"request for an email sending too frequently", @111: @"Token from email is invalid"};
        _responseErrorCodeDictionary = @{};
    }
    return _responseErrorCodeDictionary;
}

#pragma mark - init
- (id)init{
    self = [super init];
    if(self){
        /**
         *  The default timeout of 10s
         */
        self.timeoutInterval = 10.0f;
        self.showActivityIndicator = YES;
    }
    return self;
}

+ (NSString *)requestBaseUrl{
    return REQUEST_BASEURL;
}
#pragma mark Build request interface address
- (NSString *)requestUrlPath{
    return @"";
}

#pragma mark Build request parameters
- (id)parameters{
    return @{};
}

#pragma mark - public method
#pragma mark validate request parameters
- (BOOL)validateRequestParameters{
    /**
     *  The default is to verify through
     */
    return YES;
}

#pragma mark Return the data validation interfaces
- (BOOL)validateResponseData:(id) returnData HttpURLResponse: (NSURLResponse *)response{
    //获取http 状态码
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"HttpCode: %ld", (long)httpResponse.statusCode);
    if(httpResponse.statusCode > 300){
        return NO;
    }
    return YES;
}

#pragma mark The basic configuration information build request
- (BOOL)buildRequestConfigInfo{
    if (![self validateRequestParameters]) {
        [SVProgressHUD dismiss];
        return NO;
    }
    
    if (self.showActivityIndicator) {
        [SVProgressHUD show];
    }
    
    [self configTimeOut:self.networkingManager];
#pragma mark -- 单向验证 :: 下面还有一处请求需要改单项验证
    [self.networkingManager setSecurityPolicy:[self customSecurityPolicy]];
    
    [self.networkingManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"system_version"];
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        [self.networkingManager.requestSerializer setValue:CURRENT_WALLET_UID forHTTPHeaderField:@"uid"];
        
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        [self.networkingManager.requestSerializer setValue:@"6f1a8e0eb24afb7ddc829f96f9f74e9d" forHTTPHeaderField:@"uid"];
    }
    
    if ([NSBundle isChineseLanguage]) {
        [self.networkingManager.requestSerializer setValue:@"chinese" forHTTPHeaderField:@"language"];
    }else{
        [self.networkingManager.requestSerializer setValue:@"english" forHTTPHeaderField:@"language"];
    }
    
    //客服端利用p12验证服务器 , 双向验证
//    [self checkCredential:self.networkingManager];
    self.networkingManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    
    return YES;
}

- (void)getDataSusscess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure{
    if (![self buildRequestConfigInfo]) {
        return;
    }
    
    WS(weakSelf);
    id parameters = [self parameters];
    NSLog(@"REQUEST_APIPATH = %@", REQUEST_APIPATH);
    NSLog(@"parameters = %@", parameters);
    self.sessionDataTask = [self.networkingManager GET:REQUEST_APIPATH parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (IsNilOrNull(success)) {
                return ;
            }
            NSLog(@"responseObject%@", responseObject);
            success(weakSelf.networkingManager, responseObject);
        }
        
        if(self.showActivityIndicator){
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (IsNilOrNull(failure)) {
            return ;
        }
        if(error.code == -1001){
            [TOASTVIEW showWithText:NSLocalizedString(@"请求超时, 请稍后再试!", nil)];
        }
        failure(weakSelf.networkingManager, error);
        
    }];
    
}

#pragma mark The Post method request data
- (void)postDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure{
    //The basic configuration information build request
    if(![self buildRequestConfigInfo]){
        return;
    }
    
    //Start a Post request data interface
    id parameters = [self parameters];
    NSLog(@"parameters = %@", parameters);
    NSLog(@"REQUEST_APIPATH = %@", REQUEST_APIPATH);
    WS(weakSelf);
    
    self.sessionDataTask = [self.networkingManager POST: REQUEST_APIPATH parameters: parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([self validateResponseData: responseObject HttpURLResponse: task.response]) {
            if(IsNilOrNull(success)){
                return;
            }
            success(weakSelf.networkingManager, responseObject);
        }
        else{
            failure(weakSelf.networkingManager, nil);
        }
        
        //dismiss loading view
        if(self.showActivityIndicator){
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //dismiss loading view
        [SVProgressHUD dismiss];
        //failure block
        if(IsNilOrNull(failure)){
            return;
        }
        failure(task, error);
    }];
}

/**
 request Json 序列化 的 post 请求
 */
- (void)postOuterDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure{
    if (![self buildRequestConfigInfo]) {
        return;
    }
    if (self.showActivityIndicator) {
        [SVProgressHUD show];
    }
    WS(weakSelf);
    id parameters = [self parameters];
    NSLog(@"REQUEST_APIPATH = %@", REQUEST_APIPATH);
    NSLog(@"parameters = %@", parameters);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: REQUEST_BASEURL]];
    [self configTimeOut:manager];
#pragma mark -- 单向验证
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    //客服端利用p12验证服务器 , 双向验证
//    [self checkCredential:manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    // request Json 序列化
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
        [manager.requestSerializer setValue:CURRENT_WALLET_UID forHTTPHeaderField:@"uid"];
        
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        [manager.requestSerializer setValue:@"6f1a8e0eb24afb7ddc829f96f9f74e9d" forHTTPHeaderField:@"uid"];
    }
    
    if ([NSBundle isChineseLanguage]) {
        [manager.requestSerializer setValue:@"chinese" forHTTPHeaderField:@"language"];
    }else{
        [manager.requestSerializer setValue:@"english" forHTTPHeaderField:@"language"];
    }
    
    [manager POST:REQUEST_APIPATH parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (IsNilOrNull(success)) {
                return ;
            }
            if ([responseObject isKindOfClass:[NSData class]]) {
                
            }
            
            success(weakSelf.networkingManager, responseObject);
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
        if (IsNilOrNull(failure)) {
            return ;
        }
        if(error.code == -1001){
            [TOASTVIEW showWithText:NSLocalizedString(@"请求超时, 请稍后再试!", nil)];
        }
        
        failure(weakSelf.networkingManager , error);
    }];
}

// 请求超时时间
- (void)configTimeOut:(AFHTTPSessionManager *)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    ((AFJSONResponseSerializer *)self.networkingManager.responseSerializer).removesKeysWithNullValues = YES;
}

- (void)dealloc{
    if (!IsNilOrNull(self.sessionDataTask)) {
        [self.sessionDataTask cancel];
    }
}

#pragma mark - ********** SSL校验 **********
/** SSL 1.单向验证 */
- (AFSecurityPolicy*)customSecurityPolicy {
    
    // AFSSLPinningModeCertificate:需要客户端预先保存服务端的证书(自建证书)
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    NSString * cerPath  = [[NSBundle mainBundle] pathForResource:kHttpsServiceCer ofType:@"cer"];
    NSData *certData    = [NSData dataWithContentsOfFile:cerPath];
    NSSet   *dataSet    = [NSSet setWithArray:@[certData]];
    // 自建证书的时候，提供相应的证书
    [securityPolicy setPinnedCertificates:dataSet];
    // 是否允许无效证书(自建证书)
    [securityPolicy setAllowInvalidCertificates:YES];
    // 是否需要验证域名
    [securityPolicy setValidatesDomainName:NO];
    
    return securityPolicy;
}

/**
 客户端验证服务器信任凭证
 
 @param manager AFURLSessionManager
 */
- (void)checkCredential:(AFURLSessionManager *)manager
{
    
    //为了方便测试
    [manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
        NSLog(@"%s error：%@",__FUNCTION__,error);
    }];
    
    WS(weakSelf);
    __weak typeof(manager) weakManager = manager;
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential = nil;
        NSLog(@"authenticationMethod=%@",challenge.protectionSpace.authenticationMethod);
        //判断当前校验的是客户端证书还是服务器证书
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            // 客户端的安全策略来决定是否信任该服务器；不信任，则取消请求。
            //接口提示：已取消;是因为客户端设置了需要验证域名
            if([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                // 创建URL凭证
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;//使用（信任）证书
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;//默认，忽略
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;//取消
            }
        } else {
            
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust       = NULL;
            NSString *p12 = [[NSBundle mainBundle] pathForResource:kHttpsClientP12 ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:p12]){
                NSLog(@"client.p12:not exist");
            }else{
                
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                if ([weakSelf extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data]){
                    
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[]      = {certificate};
                    CFArrayRef certArray    = CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential  = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition = NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
}

//解读p12文件信息
- (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary *optionsDic = [NSDictionary dictionaryWithObject:kHttpsP12Password forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError    = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDic,&items);
    
    if(securityError == errSecSuccess) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity = NULL;
        tempIdentity    = CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity    = (SecIdentityRef)tempIdentity;
        const void*tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}


@end
