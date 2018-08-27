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
@property(nonatomic , strong) BaseLabel1 *ownerTipLabel;
@property(nonatomic , strong) UIImageView *ownerRightIconImg;
@property(nonatomic , strong) BaseLabel1 *activeTipLabel;
@property(nonatomic , strong) UIImageView *activeRightIconImg;
@end


@implementation AccountManagementHeaderView

- (BaseLabel1 *)ownerTipLabel{
    if (!_ownerTipLabel) {
        _ownerTipLabel = [[BaseLabel1 alloc] init];
        _ownerTipLabel.font = [UIFont systemFontOfSize:13];
        _ownerTipLabel.textAlignment = NSTextAlignmentRight;
        _ownerTipLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerTipLabelTapEvent)];
        [_ownerTipLabel addGestureRecognizer:tap];
    }
    return _ownerTipLabel;
}

- (UIImageView *)ownerRightIconImg{
    if (!_ownerRightIconImg) {
        _ownerRightIconImg = [[UIImageView alloc] init];
    }
    return _ownerRightIconImg;
}

- (BaseLabel1 *)activeTipLabel{
    if (!_activeTipLabel) {
        _activeTipLabel = [[BaseLabel1 alloc] init];
        _activeTipLabel.font = [UIFont systemFontOfSize:13];
        _activeTipLabel.textAlignment = NSTextAlignmentRight;
        _activeTipLabel.textColor = HEXCOLOR(0xE8554A);
    }
    return _activeTipLabel;
}

- (UIImageView *)activeRightIconImg{
    if (!_activeRightIconImg) {
        _activeRightIconImg = [[UIImageView alloc] init];
    }
    return _activeRightIconImg;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.ownerReferenceBaseView addSubview:self.ownerRightIconImg];
    [self.ownerReferenceBaseView addSubview:self.ownerTipLabel];
    
    self.ownerRightIconImg.sd_layout.rightSpaceToView(self.ownerReferenceBaseView, MARGIN_20).centerYEqualToView(self.ownerReferenceBaseView).widthIs(15).heightIs(15);
    
    self.ownerTipLabel.sd_layout.rightSpaceToView(self.ownerRightIconImg, 5).centerYEqualToView(self.ownerReferenceBaseView).widthIs(200).heightIs(21);
    
    [self.activeReferenceBaseView addSubview:self.activeRightIconImg];
    self.activeRightIconImg.sd_layout.rightSpaceToView(self.activeReferenceBaseView, MARGIN_20).centerYEqualToView(self.activeReferenceBaseView).widthIs(15).heightIs(15);
    
    [self.activeReferenceBaseView addSubview:self.activeTipLabel];
    self.activeTipLabel.sd_layout.rightSpaceToView(self.activeRightIconImg, 5).centerYEqualToView(self.activeReferenceBaseView).widthIs(200).heightIs(21);
    
}

-(void)setLocalAccount:(AccountInfo *)localAccount{
    _localAccount = localAccount;
    if (localAccount.account_owner_public_key.length<6) {
        self.ownerPublicKeyLabel.text = NSLocalizedString(@"该权限暂未导入", nil);
        self.ownerTipLabel.text = NSLocalizedString(@"导入Owner权限", nil);
        self.ownerRightIconImg.image = [UIImage imageNamed:@"right_arrow_gray"];
        [self.ownerRightIconImg sd_clearViewFrameCache];
        self.ownerRightIconImg.sd_layout.rightSpaceToView(self.ownerReferenceBaseView, MARGIN_20).centerYEqualToView(self.ownerReferenceBaseView).widthIs(7).heightIs(13);
        [self.ownerTipLabel sd_clearViewFrameCache];
        self.ownerTipLabel.sd_layout.rightSpaceToView(self.ownerRightIconImg, 5).centerYEqualToView(self.ownerReferenceBaseView).widthIs(200).heightIs(21);
        
    }else{
        self.ownerPublicKeyLabel.text = localAccount.account_owner_public_key;
        self.ownerTipLabel.hidden = YES;
        self.ownerRightIconImg.hidden = YES;
    }
    self.activePublicKeyLabel.text =  localAccount.account_active_public_key;
    
    
}

- (void)updateViewWithRemoteAccountInfo:(AccountInfo *)remoteAccount{
    // owner_public_key
    self.ownerTipLabel.hidden = NO;
    self.ownerRightIconImg.hidden = NO;
    if (!remoteAccount.account_owner_public_key) {
        self.ownerTipLabel.textColor = HEXCOLOR(0xE8554A);
        self.ownerTipLabel.text = [NSString stringWithFormat:@"%@%@", remoteAccount.account_name,NSLocalizedString(@"未创建成功", nil)];
        self.ownerRightIconImg.image = [UIImage imageNamed:@"warning_red"];
        self.ownerTipLabel.userInteractionEnabled = NO;
        
        [self.ownerRightIconImg sd_clearViewFrameCache];
        self.ownerRightIconImg.sd_layout.rightSpaceToView(self.ownerReferenceBaseView, MARGIN_20).centerYEqualToView(self.ownerReferenceBaseView).widthIs(15).heightIs(15);
        [self.ownerTipLabel sd_clearViewFrameCache];
        self.ownerTipLabel.sd_layout.rightSpaceToView(self.ownerRightIconImg, 5).centerYEqualToView(self.ownerReferenceBaseView).widthIs(200).heightIs(21);
        
    }else{
        if (_localAccount.account_owner_public_key.length>6){
            if (![_localAccount.account_owner_public_key isEqualToString:remoteAccount.account_owner_public_key]) {
                self.ownerTipLabel.textColor = HEXCOLOR(0xE8554A);
                self.ownerTipLabel.text = NSLocalizedString(@"本地私钥已失效", nil);
                self.ownerRightIconImg.image = [UIImage imageNamed:@"warning_red"];
                self.ownerTipLabel.userInteractionEnabled = NO;
                
            }
        }
    }
    
    if (!remoteAccount.account_active_public_key) {
        self.activeTipLabel.textColor = HEXCOLOR(0xE8554A);
        self.activeTipLabel.text = [NSString stringWithFormat:@"%@%@", remoteAccount.account_name,NSLocalizedString(@"未创建成功", nil)];
        self.activeRightIconImg.image = [UIImage imageNamed:@"warning_red"];
    }else{
        // owner_active_key
        if (_localAccount.account_active_public_key.length>6){
            if (![_localAccount.account_active_public_key isEqualToString:remoteAccount.account_active_public_key]) {
                self.activeTipLabel.textColor = HEXCOLOR(0xE8554A);
                self.activeTipLabel.text = NSLocalizedString(@"本地私钥已失效", nil);
                self.activeRightIconImg.image = [UIImage imageNamed:@"warning_red"];
            }
        }
        
        
    }
   
}


- (void)ownerTipLabelTapEvent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ownerTipLabelDidTap)]) {
        [self.delegate ownerTipLabelDidTap];
    }
}
@end

