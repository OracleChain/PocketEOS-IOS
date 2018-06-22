//
//  ModifyApproveView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"
#import "EOSResourceResult.h"
#import "EOSResource.h"

@protocol ModifyApproveHeaderViewDelegate<NSObject>
- (void)confirmModifyBtnDidClick:(UIButton *)sender;

@end


@interface ModifyApproveHeaderView : BaseView


@property(nonatomic , strong) EOSResourceResult *model;


@property(nonatomic, weak) id<ModifyApproveHeaderViewDelegate> delegate;

@end
