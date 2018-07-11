//
//  EOSMappingImportAccountHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSMappingImportAccountHeaderView.h"

@interface EOSMappingImportAccountHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet BaseTextView *tipTextView;
@end


@implementation EOSMappingImportAccountHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tipTextView.placeholder = NSLocalizedString(@"该功能仅适用于EOS映射获得的私钥，且每个映射获得的私钥只能创建一个的EOS账号。", nil);
}

- (IBAction)importAccount:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importEOSMappingAccountBtnDidClick)]) {
        [self.delegate importEOSMappingAccountBtnDidClick];
    }
}

@end
