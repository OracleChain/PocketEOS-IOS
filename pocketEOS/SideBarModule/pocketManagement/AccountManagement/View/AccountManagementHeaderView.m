//
//  AccountManagementHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/13.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "AccountManagementHeaderView.h"

@interface AccountManagementHeaderView()
@property (weak, nonatomic) IBOutlet UIView *ownerReferenceBaseView;
@property (weak, nonatomic) IBOutlet UIView *activeReferenceBaseView;
@property (weak, nonatomic) IBOutlet BaseLabel1 *ownerTipLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *activeTipLabel;
@property(nonatomic , strong) UILabel *ownerPublicKeyTipLabel;
@property(nonatomic , strong) UILabel *activePublicKeyTipLabel;
@end


@implementation AccountManagementHeaderView

- (UILabel *)ownerPublicKeyTipLabel{
    if (!_ownerPublicKeyTipLabel) {
        _ownerPublicKeyTipLabel = [[UILabel alloc] init];
        _ownerPublicKeyTipLabel.backgroundColor = HEXCOLOR(0xFF8080);
        _ownerPublicKeyTipLabel.textColor = HEXCOLOR(0xFFFFFF);
        _ownerPublicKeyTipLabel.font = [UIFont systemFontOfSize:12];
        _ownerPublicKeyTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ownerPublicKeyTipLabel;
}

- (UILabel *)activePublicKeyTipLabel{
    if (!_activePublicKeyTipLabel) {
        _activePublicKeyTipLabel = [[UILabel alloc] init];
        _activePublicKeyTipLabel.backgroundColor = HEXCOLOR(0xFF8080);
        _activePublicKeyTipLabel.textColor = HEXCOLOR(0xFFFFFF);
        _activePublicKeyTipLabel.font = [UIFont systemFontOfSize:12];
        _activePublicKeyTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _activePublicKeyTipLabel;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyActivePublicKeyToPasteboard:)];
    self.activePublicKeyLabel.userInteractionEnabled = YES;
    [self.activePublicKeyLabel addGestureRecognizer:longPressGesture];
    
    UILongPressGestureRecognizer *longPressGesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyOwnerPublicKeyToPasteboard:)];
    self.ownerPublicKeyLabel.userInteractionEnabled = YES;
    [self.ownerPublicKeyLabel addGestureRecognizer:longPressGesture1];
    
}

-(void)setLocalAccount:(AccountInfo *)localAccount{
    _localAccount = localAccount;
    if (localAccount.account_owner_public_key.length<6) {
        [self.ownerPublicKeyLabel addSubview:self.ownerPublicKeyTipLabel];
        self.ownerPublicKeyTipLabel.text = NSLocalizedString(@"该权限暂未导入", nil);
        [self configOwnerPublicKeyTipLabelWidth];
        
        self.ownerTipLabel.text = NSLocalizedString(@"导入私钥", nil);
        
    }else{
        self.ownerPublicKeyLabel.text = localAccount.account_owner_public_key;
        [self.ownerPublicKeyTipLabel removeFromSuperview];
        self.ownerTipLabel.text = NSLocalizedString(@"变更私钥", nil);

    }
    
    
    
    if (localAccount.account_active_public_key.length<6) {
        [self.activePublicKeyLabel addSubview:self.activePublicKeyTipLabel];
        self.activePublicKeyTipLabel.text = NSLocalizedString(@"该权限暂未导入", nil);
        [self configActivePublicKeyTipLabelWidth];
        self.activeTipLabel.text = NSLocalizedString(@"导入私钥", nil);
        
    }else{
        self.activePublicKeyLabel.text = localAccount.account_active_public_key;
        [self.activePublicKeyTipLabel removeFromSuperview];
        self.activeTipLabel.text = NSLocalizedString(@"变更私钥", nil);
        
    }
    
    
}


- (void)updateViewWithGet_account_permission_service:(Get_account_permission_service *)get_account_permission_service{
    // owner_public_key
    self.ownerTipLabel.hidden = NO;
    
    if (get_account_permission_service.chainAccountOwnerPublicKeyArray.count==0) {
        self.ownerTipLabel.textColor = HEXCOLOR(0xE8554A);
        self.ownerTipLabel.text = [NSString stringWithFormat:@"%@%@", self.localAccount.account_name,NSLocalizedString(@"未创建成功", nil)];
        
    }else{
        if (_localAccount.account_owner_public_key.length>6){
            if (![get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:_localAccount.account_owner_public_key]) {
                [self.ownerPublicKeyLabel addSubview:self.ownerPublicKeyTipLabel];
                _ownerPublicKeyTipLabel.text = NSLocalizedString(@"私钥已失效", nil);
                [self configOwnerPublicKeyTipLabelWidth];
                
                
                self.ownerPublicKeyLabel.text = @"";
            }
        }
    }
    
    if (get_account_permission_service.chainAccountActivePublicKeyArray.count==0) {
        self.activeTipLabel.textColor = HEXCOLOR(0xE8554A);
        self.activeTipLabel.text = [NSString stringWithFormat:@"%@%@", _localAccount.account_name,NSLocalizedString(@"未创建成功", nil)];
    }else{
        // owner_active_key
        if (_localAccount.account_active_public_key.length>6){
            if (![get_account_permission_service.chainAccountActivePublicKeyArray containsObject:_localAccount.account_active_public_key]) {
                [self.activePublicKeyLabel addSubview:self.activePublicKeyTipLabel];
                _activePublicKeyTipLabel.text = NSLocalizedString(@"私钥已失效", nil);
                [self configActivePublicKeyTipLabelWidth];
                
                
                self.activePublicKeyLabel.text = @"";
                
            }
        }
    }
    
}

- (void)copyActivePublicKeyToPasteboard:(UILongPressGestureRecognizer *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [(UILabel *)sender.view text];
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
}

- (void)copyOwnerPublicKeyToPasteboard:(UILongPressGestureRecognizer *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [(UILabel *)sender.view text];
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
}


- (IBAction)ownerTipBtnClick:(UIButton *)sender {
    if ([self.ownerTipLabel.text isEqualToString: NSLocalizedString(@"导入私钥", nil) ]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shouldImportOwnerPrivateKey)]) {
            [self.delegate shouldImportOwnerPrivateKey];
        }
        
    }else if ([self.ownerTipLabel.text isEqualToString: NSLocalizedString(@"变更私钥", nil) ]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(shouldResetOwnerPrivateKey)]) {
            [self.delegate shouldResetOwnerPrivateKey];
        }
        
    }
  
}



- (IBAction)activeTipBtnClick:(UIButton *)sender {
    if ([self.activeTipLabel.text isEqualToString: NSLocalizedString(@"导入私钥", nil) ]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shouldImportActivePrivateKey)]) {
            [self.delegate shouldImportActivePrivateKey];
        }
        
    }else if ([self.activeTipLabel.text isEqualToString: NSLocalizedString(@"变更私钥", nil) ]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(shouldResetActivePrivateKey)]) {
            [self.delegate shouldResetActivePrivateKey];
        }

    }
    
}


- (void)configOwnerPublicKeyTipLabelWidth{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName:HEXCOLOR(0xFFFFFF)
                                 };
    CGSize calculatedSize = [_ownerPublicKeyTipLabel.text boundingRectWithSize:CGSizeMake(100, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    _ownerPublicKeyTipLabel.frame = CGRectMake(0, MARGIN_20, calculatedSize.width+MARGIN_10, 17);
}

- (void)configActivePublicKeyTipLabelWidth{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName:HEXCOLOR(0xFFFFFF)
                                 };
    CGSize calculatedSize = [_activePublicKeyTipLabel.text boundingRectWithSize:CGSizeMake(100, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    _activePublicKeyTipLabel.frame = CGRectMake(0, MARGIN_20, calculatedSize.width+MARGIN_10, 17);
}

@end



