//
//  RedPacketRecordsTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "RedPacketRecordsTableViewCell.h"

@interface RedPacketRecordsTableViewCell()
@property(nonatomic, strong) BaseLabel *titleLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic , strong) UILabel *detailLabel;
@end


@implementation RedPacketRecordsTableViewCell

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

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = HEXCOLOR(0xB0B0B0);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = HEXCOLOR(0xB0B0B0);
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 16).heightIs(20).widthIs(SCREEN_WIDTH/2 - MARGIN_20);
        
        [self.contentView addSubview:self.amountLabel];
        self.amountLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 16).heightIs(20);
        [self.amountLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH / 2];
        
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.sd_layout.leftEqualToView(self.titleLabel).topSpaceToView(self.titleLabel, 1).widthIs(200).heightIs(20);
        
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.amountLabel, 1).heightIs(20).widthIs(150);
        
    }
    return self;
}

- (void)setModel:(RedPacketRecord *)model{

    if (model.isSend) {
        NSInteger isRod = model.packetCount.integerValue - model.residueCount.integerValue;
        self.amountLabel.textColor = LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE ? HEXCOLOR(0xFFFFFF ) : HEXCOLOR(0x140F26 );
        if (model.status.integerValue == 0 || model.status.integerValue == 3 ) {
            //正常可以领取(包含领取完毕的红包)
            if (model.residueCount.integerValue == 0){//已领完
                self.detailLabel.text = [NSString stringWithFormat:@"%@%ld/%@%@", NSLocalizedString(@"已领完", nil), (long)isRod, model.packetCount, NSLocalizedString(@"个", nil)];
            }else {
                self.detailLabel.text = [NSString stringWithFormat:@"%ld/%@%@",  isRod, model.packetCount, NSLocalizedString(@"个", nil)];
                
            }
            self.titleLabel.text = NSLocalizedString(@"发红包", nil);
            self.amountLabel.text = [NSString stringWithFormat:@"-%@ %@",  model.amount, model.type];
     
        }else if (model.status.integerValue == 1){//等待主网确认
            self.titleLabel.text = NSLocalizedString(@"红包准备中", nil);
            self.amountLabel.text = [NSString stringWithFormat:@"-%@ %@",  model.amount, model.type];
            self.detailLabel.text = @"";
        }else if (model.status.integerValue == 5){//发送失败
            self.titleLabel.text = NSLocalizedString(@"发送失败", nil);
            self.amountLabel.text = NSLocalizedString(@"无扣款", nil);
            self.detailLabel.text = @"";
        }else if (model.status.integerValue == 4){//已经退回
            self.titleLabel.text = NSLocalizedString(@"发红包", nil);
            self.detailLabel.text = [NSString stringWithFormat:@"%@%ld/%@%@", NSLocalizedString(@"已过期", nil), (long)isRod, model.packetCount, NSLocalizedString(@"个", nil)];
            self.amountLabel.text = [NSString stringWithFormat:@"-%@ %@",  model.amount, model.type];
        }
        
        
    }else{
        self.titleLabel.text = NSLocalizedString(@"收红包", nil);
        self.amountLabel.text = [NSString stringWithFormat:@"+%@ %@",  model.amount, model.type];
        self.amountLabel.textColor = HEXCOLOR(0xE903C);
        self.detailLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"接受自", nil), @"oraclechain4"];
    }
    
    self.timeLabel.text = model.createTime;
}


@end
