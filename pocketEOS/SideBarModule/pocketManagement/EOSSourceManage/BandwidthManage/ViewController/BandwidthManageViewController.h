//
//  BandwidthManageViewController.h
//  pocketEOS
//
//  Created by 师巍巍 on 21/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseViewController.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"
#import "EOSResourceCellModel.h"

@interface BandwidthManageViewController : BaseViewController

@property (nonatomic , strong) NSMutableArray *dataSourceArray;
@property (nonatomic , retain) UINavigationController *navigationController;
@property(nonatomic , strong) EOSResourceResult *eosResourceResult;

@end
