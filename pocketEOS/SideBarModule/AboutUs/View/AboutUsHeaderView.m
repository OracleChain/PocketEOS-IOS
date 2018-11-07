//
//  AboutUsHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AboutUsHeaderView.h"

@interface AboutUsHeaderView ()
@property(nonatomic , copy) NSString *officialWebsite;
@end

@implementation AboutUsHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copySubscriptionLabelTextToPasteboard:)];
    self.wechatSubscriptionLabel.userInteractionEnabled = YES;
    [self.wechatSubscriptionLabel addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyServiceLabelTextToPasteboard:)];
    self.wechatServiceLabel.userInteractionEnabled = YES;
    [self.wechatServiceLabel addGestureRecognizer:tapGesture1];
    
}

- (void)copySubscriptionLabelTextToPasteboard:(UITapGestureRecognizer *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [(UILabel *)sender.view text];
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
}

- (void)copyServiceLabelTextToPasteboard:(UITapGestureRecognizer *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [(UILabel *)sender.view text];
    [TOASTVIEW showWithText:NSLocalizedString(@"复制成功", nil)];
}


- (IBAction)officialSiteBtnClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: IsStrEmpty(self.officialWebsite) ?  @"https://oraclechain.io" :  self.officialWebsite]];
}


- (void)updateViewWithModel:(Get_pocketeos_info_Result *)model{
    self.wechatSubscriptionLabel.text = model.weChatOfficialAccount;
    self.wechatServiceLabel.text = model.weChat;
    self.AboutUsdetailTextView.text = model.companyProfile;
    self.officialWebsite = model.officialWebsite;
}

@end
