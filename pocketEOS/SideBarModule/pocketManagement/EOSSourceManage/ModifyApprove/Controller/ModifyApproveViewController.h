//
//  ModifyApproveViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"
#import "AccountResult.h"

@interface ModifyApproveViewController : BaseViewController
@property(nonatomic , copy) NSString *pageType;
@property(nonatomic , strong) EOSResourceResult *eosResourceResult;
@property(nonatomic , strong) AccountResult *accountResult;
@end
