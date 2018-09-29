//
//  ExcuteActionsContentTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/15.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#define ExcuteActionsContentTableViewCellItemHeight 44.5

#import "ExcuteActionsContentTableViewCell.h"

@interface ExcuteActionsContentTableViewCell()
@property(nonatomic , strong) BaseLabel1 *contractLabel;
@property(nonatomic , strong) BaseLabel1 *actionLabel;
@property(nonatomic , strong) BaseLabel1 *accountLabel;
@property(nonatomic , strong) BaseLabel1 *contentLabel;

@property(nonatomic , strong) BaseSlimLineView *line1;
@property(nonatomic , strong) BaseSlimLineView *line2;
@property(nonatomic , strong) BaseSlimLineView *line3;

@property(nonatomic , strong) BaseLabel *contractDetailLabel;
@property(nonatomic , strong) BaseLabel *actionDetailLabel;
@property(nonatomic , strong) BaseLabel *accountDetailLabel;
@property(nonatomic , strong) BaseLabel *contentDetailLabel;


@end


@implementation ExcuteActionsContentTableViewCell

- (BaseLabel1 *)contractLabel{
    if (!_contractLabel) {
        _contractLabel = [[BaseLabel1 alloc] init];
        _contractLabel.text = NSLocalizedString(@"合约名字", nil);
        _contractLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contractLabel;
}

- (BaseLabel1 *)actionLabel{
    if (!_actionLabel) {
        _actionLabel = [[BaseLabel1 alloc] init];
        _actionLabel.text = NSLocalizedString(@"动作", nil);
        _actionLabel.font = [UIFont systemFontOfSize:14];
    }
    return _actionLabel;
}

- (BaseLabel1 *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[BaseLabel1 alloc] init];
        _accountLabel.text = NSLocalizedString(@"操作账号", nil);
        _accountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _accountLabel;
}

- (BaseLabel1 *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[BaseLabel1 alloc] init];
        _contentLabel.text = NSLocalizedString(@"内容", nil);
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (BaseSlimLineView *)line1{
    if (!_line1) {
        _line1 = [[BaseSlimLineView alloc] init];
    }
    return _line1;
}

- (BaseSlimLineView *)line2{
    if (!_line2) {
        _line2 = [[BaseSlimLineView alloc] init];
    }
    return _line2;
}

- (BaseSlimLineView *)line3{
    if (!_line3) {
        _line3 = [[BaseSlimLineView alloc] init];
    }
    return _line3;
}


- (BaseLabel *)contractDetailLabel{
    if (!_contractDetailLabel) {
        _contractDetailLabel = [[BaseLabel alloc] init];
        _contractDetailLabel.textAlignment = NSTextAlignmentRight;
        _contractDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contractDetailLabel;
}

- (BaseLabel *)actionDetailLabel{
    if (!_actionDetailLabel) {
        _actionDetailLabel = [[BaseLabel alloc] init];
        _actionDetailLabel.textAlignment = NSTextAlignmentRight;
        _actionDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _actionDetailLabel;
}

- (BaseLabel *)accountDetailLabel{
    if (!_accountDetailLabel) {
        _accountDetailLabel = [[BaseLabel alloc] init];
        _accountDetailLabel.textAlignment = NSTextAlignmentRight;
        _accountDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _accountDetailLabel;
}


- (BaseLabel *)contentDetailLabel{
    if (!_contentDetailLabel) {
        _contentDetailLabel = [[BaseLabel alloc] init];
        _contentDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentDetailLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // contract
        [self.contentView addSubview:self.contractLabel];
        self.contractLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 0).heightIs(ExcuteActionsContentTableViewCellItemHeight).widthIs(150);
        
        [self.contentView addSubview:self.contractDetailLabel];
        self.contractDetailLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contractLabel).heightIs(ExcuteActionsContentTableViewCellItemHeight).widthIs(200);
        
        [self.contentView addSubview:self.line1];
        self.line1.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contractLabel, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
        
        // action
        [self.contentView addSubview:self.actionLabel];
        self.actionLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.line1, 0).heightIs(ExcuteActionsContentTableViewCellItemHeight).widthIs(150);
        
        [self.contentView addSubview:self.actionDetailLabel];
        self.actionDetailLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.actionLabel).heightIs(ExcuteActionsContentTableViewCellItemHeight).widthIs(200);
        
        [self.contentView addSubview:self.line2];
        self.line2.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).rightSpaceToView(self.contentView, 0).topSpaceToView(self.actionLabel, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
        
        // account
        [self.contentView addSubview:self.accountLabel];
        self.accountLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.line2, 0).heightIs(ExcuteActionsContentTableViewCellItemHeight).widthIs(150);
        
        [self.contentView addSubview:self.accountDetailLabel];
        self.accountDetailLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.accountLabel).heightIs(ExcuteActionsContentTableViewCellItemHeight).widthIs(200);
        
        [self.contentView addSubview:self.line3];
        self.line3.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).rightSpaceToView(self.contentView, 0).topSpaceToView(self.accountLabel, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
        
        
        // content
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.line3, 0).heightIs(ExcuteActionsContentTableViewCellItemHeight).widthIs(100);
        
        [self.contentView addSubview:self.contentDetailLabel];
        self.contentDetailLabel.sd_layout.leftSpaceToView(self.contentLabel, MARGIN_20).rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.line3, 12).autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:self.contentDetailLabel bottomMargin:MARGIN_10];
    }
    return self;
}

-(void)setModel:(ExcuteActions *)model{
    _model = model;
    self.contractDetailLabel.text = model.account;
    self.actionDetailLabel.text = model.name;
    if (model.authorization.count>0) {
        NSDictionary *authorizationDict = model.authorization[0];
        self.accountDetailLabel.text = authorizationDict[@"actor"];
    }
    
    NSString *contentJsonStr = [model.data mj_JSONString];
    NSString *contentJsonResultStr =[contentJsonStr stringByReplacingOccurrencesOfString:@"," withString:@",\n"];
    NSString *finalStr ;
    if (contentJsonResultStr.length>2) {
        finalStr = [contentJsonResultStr substringWithRange:NSMakeRange(1, contentJsonResultStr.length-2)];
    }
    
    self.contentDetailLabel.text = finalStr.length > 0 ? finalStr : @" ";
}

@end
