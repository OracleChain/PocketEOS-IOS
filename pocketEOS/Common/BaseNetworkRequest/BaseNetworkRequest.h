//
//  BaseNetworkRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2017/11/29.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^RequestSuccessBlock)(id DAO , id data);
typedef void(^RequestFailedBlock)(id DAO, NSError *error);

@interface BaseNetworkRequest : NSObject


/**
 Network request timeout
 */
@property(nonatomic, assign) CGFloat timeoutInterval;

@property(nonatomic, assign) BOOL showActivityIndicator;



/**
 request data
 */
@property(nonatomic, strong) NSURLSessionDataTask *sessionDataTask;

- (NSString *)requestUrlPath;


/**
 请求的基本路径

 @return 请求的基本路径
 */
+ (NSString *)requestBaseUrl;

/**
 验证参数
 */
- (BOOL)validateRequestParameters;

- (id)parameters;

- (void)getDataSusscess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

- (void)postDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

- (void)putDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

- (void)deleteDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

- (void)uploadData:(NSData *)imageData externName:(NSString *)externName success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

- (void)getOuterDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

/**
 request Json 序列化 的 post 请求
 */
- (void)postOuterDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

- (void)requestOuterUrl:(NSString *)requestUrl success:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

@end

