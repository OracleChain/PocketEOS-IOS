//
//  Search_token_request.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/18.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Search_token_request.h"

@implementation Search_token_request
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/search_token?key=%@&accountName=%@", REQUEST_PERSONAL_BASEURL, self.key, self.accountName];
}
@end
