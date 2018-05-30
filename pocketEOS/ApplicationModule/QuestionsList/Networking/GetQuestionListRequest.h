//
//  GetQuestionListRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/3.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetQuestionListRequest : BaseNetworkRequest

/**
 askid=-1表示查询所有问题，否则为查询具体问题id
 */
@property(nonatomic, strong) NSNumber *askid;

/**
 releasedLable=0表示问题还可以回答releasedLable=1表示以往问题
 */
@property(nonatomic, strong) NSNumber *releasedLable;
@property(nonatomic, strong) NSNumber *pageNum;
@property(nonatomic, strong) NSNumber *pageSize;

@end
