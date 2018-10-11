//
//  ArchiveUtil.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ArchiveUtil.h"

@implementation ArchiveUtil

+ (NSArray *)unarchiveTokenInfoArray{
    //沙盒ducument目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //完整的文件路径
    NSString *path = [docPath stringByAppendingPathComponent: LOCAL_CURRENT_TOKEN_INFO_ARRAY_FILENAME];
    
    NSArray *tokeninfo_arr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return tokeninfo_arr;
}

@end
