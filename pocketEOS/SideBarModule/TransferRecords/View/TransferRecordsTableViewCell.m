//
//  TransferRecordsTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TransferRecordsTableViewCell.h"

@interface TransferRecordsTableViewCell()
@property(nonatomic, strong) BaseLabel *titleLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UILabel *belongBlockLabel;
@end


@implementation TransferRecordsTableViewCell

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont boldSystemFontOfSize:15];
        _amountLabel.textColor = HEXCOLOR(0x140F26 );
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

- (UILabel *)belongBlockLabel{
    if (!_belongBlockLabel) {
        _belongBlockLabel = [[UILabel alloc] init];
        _belongBlockLabel.font = [UIFont systemFontOfSize:14];
        _belongBlockLabel.textColor = HEXCOLOR(0xB0B0B0);
        _belongBlockLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _belongBlockLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 16).heightIs(20).widthIs(SCREEN_WIDTH - (2 * MARGIN_20) - 80);
        
        [self.contentView addSubview:self.amountLabel];
        self.amountLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 16).heightIs(20);
        [self.amountLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH / 2];
        
        [self.contentView addSubview:self.belongBlockLabel];
        self.belongBlockLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.titleLabel, 1).heightIs(20);
        [self.belongBlockLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH / 2];
        
    }
    return self;
}

- (void)setModel:(TransactionRecord *)model{
    if ([model.from isEqualToString:RedPacketReciever] || [model.to isEqualToString:RedPacketReciever]) {
        // redpacket
        if ([model.from isEqualToString:RedPacketReciever]) {
            self.titleLabel.text = [NSString stringWithFormat: NSLocalizedString(@"红包入账", nil)];
        }else if ([model.to isEqualToString:RedPacketReciever]){
            self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"发出红包", nil)];
        }
    }else{
        // transfer
        if ([self.currentAccountName isEqualToString:model.from]) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"发送给", nil), model.to];
        }else if ([self.currentAccountName isEqualToString:model.to]){
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"接受自", nil), model.from];
        }
    }
    
    if ([self.currentAccountName isEqualToString:model.from]) {
        self.amountLabel.text = [NSString stringWithFormat:@"-%@",  model.quantity];
        
        self.amountLabel.textColor = LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE ? HEXCOLOR(0xFFFFFF ) : HEXCOLOR(0x140F26 );
    }else if([self.currentAccountName isEqualToString:model.to]){
        self.amountLabel.text = [NSString stringWithFormat:@"+%@",  model.quantity];
        self.amountLabel.textColor = HEXCOLOR(0xE903C);
    }
    
    
    self.belongBlockLabel.text = [NSDate getLocalDateTimeFromUTC:model.time];

}

@end
