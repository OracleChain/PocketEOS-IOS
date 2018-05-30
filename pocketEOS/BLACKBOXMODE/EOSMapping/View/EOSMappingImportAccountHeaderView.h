//
//  EOSMappingImportAccountHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

@protocol EOSMappingImportAccountHeaderViewDelegate<NSObject>
- (void)importEOSMappingAccountBtnDidClick;
@end


@interface EOSMappingImportAccountHeaderView : BaseView
@property(nonatomic, weak) id<EOSMappingImportAccountHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;
@property (weak, nonatomic) IBOutlet UITextField *privateKeyTF;

@end
