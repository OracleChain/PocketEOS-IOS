//
//  Candy_task_list_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/24.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Candy_task_list_request.h"

@implementation Candy_task_list_request


-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/get_user_task/%@", REQUEST_CANDYSYSTEM_BASEURL, self.uid];
    
}

@end
