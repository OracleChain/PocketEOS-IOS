//
//  AssestsMainTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/31.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "AssestsMainTableViewCell.h"
#import "Assests.h"

@interface AssestsMainTableViewCell()

@property(nonatomic, strong) UIImageView *assestsImg;
@property(nonatomic, strong) UILabel *nowPriceLabel;
@property(nonatomic, strong) UILabel *assestsBalanceLable;
@property(nonatomic, strong) UILabel *assestsBalanceCnyLabel;
@property(nonatomic , strong) UILabel *lable_24h;
@property(nonatomic , strong) UILabel *lable_nowPrice;// 现价
@property(nonatomic , strong) UIView *bottomLineView;

@end

@implementation AssestsMainTableViewCell

- (UIImageView *)assestsImg{
    if (!_assestsImg) {
        _assestsImg = [[UIImageView alloc] init];
        _assestsImg.sd_cornerRadius = @(8);
    }
    return _assestsImg;
}

- (UILabel *)assestsPriceChangeLabel{
    if (!_assestsPriceChangeLabel) {
        _assestsPriceChangeLabel = [[UILabel alloc] init];
        _assestsPriceChangeLabel.font = [UIFont systemFontOfSize:14];
        _assestsPriceChangeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _assestsPriceChangeLabel;
}

- (UILabel *)nowPriceLabel{
    if (!_nowPriceLabel) {
        _nowPriceLabel = [[UILabel alloc] init];
        _nowPriceLabel.font = [UIFont systemFontOfSize:14];
        _nowPriceLabel.textColor = HEXCOLOR(0xB0B0B0);
        _nowPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nowPriceLabel;
}

- (UILabel *)assestsBalanceLable{
    if (!_assestsBalanceLable) {
        _assestsBalanceLable = [[UILabel alloc] init];
        _assestsBalanceLable.font = [UIFont boldSystemFontOfSize:16];
        _assestsBalanceLable.textColor = HEXCOLOR(0x2A2A2A);
    }
    return _assestsBalanceLable;
}

- (UILabel *)assestsBalanceCnyLabel{
    if (!_assestsBalanceCnyLabel) {
        _assestsBalanceCnyLabel = [[UILabel alloc] init];
        _assestsBalanceCnyLabel.font = [UIFont systemFontOfSize:14];
        _assestsBalanceCnyLabel.textColor = HEXCOLOR(0xB0B0B0 );
    }
    return _assestsBalanceCnyLabel;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _bottomLineView;
}

- (UILabel *)lable_24h{
    if (!_lable_24h) {
        _lable_24h = [[UILabel alloc] init];
        _lable_24h.text =@"24h";
        _lable_24h.textColor = HEXCOLOR(0xB0B0B0 );
        _lable_24h.font = [UIFont systemFontOfSize:14];
    }
    return _lable_24h;
}

- (UILabel *)lable_nowPrice{
    if (!_lable_nowPrice) {
        _lable_nowPrice = [[UILabel alloc] init];
        _lable_nowPrice.text = @"现价";
        _lable_nowPrice.textColor = HEXCOLOR(0xB0B0B0 );
        _lable_nowPrice.font = [UIFont systemFontOfSize:14];
    }
    return _lable_nowPrice;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat topSpace = 18.5;
        CGFloat labelHeight = 16;
        [self.contentView addSubview:self.assestsImg];
        self.assestsImg.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).widthIs(40).heightEqualToWidth();
        
        [self.contentView addSubview:self.lable_24h];
        self.lable_24h.sd_layout.topSpaceToView(self.contentView, topSpace).rightSpaceToView(self.contentView, MARGIN_20).widthIs(30).heightIs(labelHeight);
        
        [self.contentView addSubview:self.assestsPriceChangeLabel];
      self.assestsPriceChangeLabel.sd_layout.topSpaceToView(self.contentView, topSpace).rightSpaceToView(self.lable_24h, 8).widthIs(100).heightIs(labelHeight);
        
        [self.contentView addSubview:self.lable_nowPrice];
        self.lable_nowPrice.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(_lable_24h, 8).widthIs(30).heightIs(labelHeight);

        [self.contentView addSubview:self.nowPriceLabel];
        self.nowPriceLabel.sd_layout.rightSpaceToView(self.lable_nowPrice, 8).centerYEqualToView(_lable_nowPrice).widthIs(200).heightIs(labelHeight);

        [self.contentView addSubview:self.assestsBalanceLable];
        self.assestsBalanceLable.sd_layout.leftSpaceToView(_assestsImg, MARGIN_15).topSpaceToView(self.contentView, topSpace).rightSpaceToView(_assestsPriceChangeLabel, 8).heightIs(labelHeight);

        [self.contentView addSubview:self.assestsBalanceCnyLabel];
        self.assestsBalanceCnyLabel.sd_layout.leftSpaceToView(_assestsImg, MARGIN_15).centerYEqualToView(_lable_nowPrice).rightSpaceToView(_assestsPriceChangeLabel, 8).heightIs(labelHeight);
        
        
        [self.contentView addSubview:self.bottomLineView];
        self.bottomLineView.sd_layout.leftSpaceToView(self.contentView, 73).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    }
    return self;
}

-(void)setModel:(Assests *)model{
    self.assestsImg.image = [UIImage imageNamed:model.assests_avtar];

    self.assestsBalanceLable.text = [NSString stringWithFormat:@"%@ %@", VALIDATE_STRING([NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.assests_balance.doubleValue ]]), VALIDATE_STRING(model.assestsName)];
    
    self.assestsBalanceCnyLabel.text = [NSString stringWithFormat:@"≈%@ CNY", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.assests_balance_cny.doubleValue ]]];
    
    self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@", [NumberFormatter displayStringFromNumber:[NSNumber numberWithDouble:model.assests_price_cny.doubleValue ]]];
}
@end
