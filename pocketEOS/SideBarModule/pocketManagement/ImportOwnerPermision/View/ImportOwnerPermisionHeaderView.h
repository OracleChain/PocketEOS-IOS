//
//  ImportOwnerPermisionHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/30.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

@protocol ImportOwnerPermisionHeaderViewDelegate<NSObject>

- (void)importBtnDidClick:(UIButton *)sender;
@end


@interface ImportOwnerPermisionHeaderView : BaseView

@property (weak, nonatomic) IBOutlet UITextField *private_ownerKey_TF;

@property(nonatomic, weak) id<ImportOwnerPermisionHeaderViewDelegate> delegate;

@end
