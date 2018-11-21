//
//  ImportAccount_AccounsNameDataSourceViewTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccount_AccounsNameDataSourceViewTableViewCell.h"

@interface ImportAccount_AccounsNameDataSourceViewTableViewCell ()
@property(nonatomic , strong) UILabel *detailLabel;
@end

@implementation ImportAccount_AccounsNameDataSourceViewTableViewCell

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:10];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.layer.cornerRadius = 2;
        _detailLabel.layer.masksToBounds =YES;
        _detailLabel.layer.borderWidth = 1;
    }
    return _detailLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}


-(void)setModel:(ImportAccountModel *)model{
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.bottomLineView.hidden = NO;
    self.textLabel.text = model.accountName;
    
    
    // 账号状态 0 ：未导入 1 ： 已经导入 2 ：导入失败 3 :本地存在 4:权限错误
    if (model.status == 0) {
        self.detailLabel.text = NSLocalizedString(@"点击导入", nil);
        self.detailLabel.textColor = HEXCOLOR(0x82A2FF);
    }else if (model.status == 1){
        self.detailLabel.text = NSLocalizedString(@"导入成功", nil);
        self.detailLabel.textColor = HEXCOLOR(0xCCCCCC);
    }else if (model.status == 2){
        self.detailLabel.text = NSLocalizedString(@"导入失败", nil);
        self.detailLabel.textColor = HEXCOLOR(0xFF6565);
    }else if (model.status == 3){
        self.detailLabel.text = NSLocalizedString(@"本地存在", nil);
        self.detailLabel.textColor = HEXCOLOR(0xCCCCCC);
    }else if (model.status == 4){
        self.detailLabel.text = NSLocalizedString(@"权限错误", nil);
        self.detailLabel.textColor = HEXCOLOR(0xFF6565);
    }
    _detailLabel.layer.borderColor = _detailLabel.textColor.CGColor;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:10]
                                 };
    CGSize calculatedSize = [self.detailLabel.text boundingRectWithSize:CGSizeMake(100, 22) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    
    self.detailLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).heightIs(22).widthIs(calculatedSize.width + MARGIN_20);
    
    
    
}


@end
