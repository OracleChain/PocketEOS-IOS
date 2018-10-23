//
//  DappChangeAccountOnNavigationRightView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DappChangeAccountOnNavigationRightView.h"

@interface DappChangeAccountOnNavigationRightView ()
@property(nonatomic , strong) UIImageView *avatarImgView;

@property(nonatomic , strong) UIImageView *downImgView;
@end

@implementation DappChangeAccountOnNavigationRightView

- (UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.image = [UIImage imageNamed:@"avatar_icon_black"];
    }
    return _avatarImgView;
}

- (UILabel *)accountNameLabel{
    if (!_accountNameLabel) {
        _accountNameLabel = [[UILabel alloc] init];
        _accountNameLabel.font = [UIFont systemFontOfSize:13];
        _accountNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _accountNameLabel;
}

- (UIImageView *)downImgView{
    if (!_downImgView) {
        _downImgView = [[UIImageView alloc] init];
        _downImgView.image = [UIImage imageNamed:@"downArrow_black"];
    }
    return _downImgView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.avatarImgView.userInteractionEnabled = YES;
        self.accountNameLabel.userInteractionEnabled = YES;
        self.downImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dappChangeAccountOnNavigationRightViewClick)];
        [self addGestureRecognizer:tap];
        
        
        [self addSubview:self.avatarImgView];
        self.avatarImgView.sd_layout.leftSpaceToView(self, 0).centerYEqualToView(self).widthIs(13).heightIs(13);
        
        [self addSubview:self.accountNameLabel];
        self.accountNameLabel.sd_layout.leftSpaceToView(self.avatarImgView, 5).centerYEqualToView(self.avatarImgView).widthIs(41).heightIs(13);
        
        [self addSubview:self.downImgView];
        self.downImgView.sd_layout.leftSpaceToView(self.accountNameLabel, 4).centerYEqualToView(self.avatarImgView).widthIs(6).heightIs(4);
        
    }
    return self;
}

- (void)dappChangeAccountOnNavigationRightViewClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dappChangeAccountOnNavigationRightViewDidClick)]) {
        [self.delegate dappChangeAccountOnNavigationRightViewDidClick];
    }
}


@end
