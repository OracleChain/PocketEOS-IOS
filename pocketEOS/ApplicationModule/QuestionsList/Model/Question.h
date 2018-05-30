//
//  Question.h
//  pocketEOS
//
//  Created by oraclechain on 2018/2/5.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AskTitle;
@interface Question : NSObject
@property(nonatomic, copy) NSNumber *question_id;
@property(nonatomic, copy) NSString *endtime;
@property(nonatomic, copy) NSString *from;
@property(nonatomic, copy) NSString *oct;
@property(nonatomic, copy) NSString *releasedLable;
@property(nonatomic, copy) NSString *createtime;
@property(nonatomic, copy) NSString *optionanswerscnt;

// asktitle
@property(nonatomic, strong) AskTitle *asktitle;

@property(nonatomic, copy) NSString *optionanswers;

@end
