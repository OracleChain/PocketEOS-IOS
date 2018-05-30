//
//  CandyTaskModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CandyTaskModel : NSObject

@property(nonatomic , copy) NSString *task_id;
@property(nonatomic , copy) NSString *title;
@property(nonatomic , copy) NSString *task_description;
@property(nonatomic , copy) NSString *avatar;
@property(nonatomic , copy) NSString *scoreNum;
@property(nonatomic , copy) NSString *taskUrl;
@property(nonatomic , copy) NSString *createTime;
@property(nonatomic , copy) NSString *updateTime;
@property(nonatomic , assign) BOOL completed;


@end
