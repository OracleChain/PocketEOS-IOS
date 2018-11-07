//
//  TransferDetailsTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "TransferDetailsTableViewCell.h"

@interface TransferDetailsTableViewCell()

@property(nonatomic, strong) BaseLabel1 *titleLabel;
@property(nonatomic, strong) BaseLabel *detailLabel;
@end


@implementation TransferDetailsTableViewCell

- (BaseLabel1 *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel1 alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (BaseLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        
        
    }
    return _detailLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bottomLineView.hidden = YES;
       
        
    }
    return self;
}


-(void)setModel:(OptionModel *)model{
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 16).heightIs(20);
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    [self.contentView addSubview:self.detailLabel];
    self.rightIconImageView.image = [UIImage imageNamed:@"copy-icon_gray"];
    if (model.canCopy) {
        [self.contentView addSubview:self.rightIconImageView];
        self.rightIconImageView.sd_layout.rightSpaceToView(self.contentView, 16).centerYEqualToView(self.titleLabel).widthIs(14).heightIs(14);
        
        self.detailLabel.sd_layout.leftSpaceToView(self.titleLabel , 50).rightSpaceToView(self.rightIconImageView, MARGIN_10).topSpaceToView(self.contentView, 16).autoHeightRatio(0);
        
        
    }else{
        self.detailLabel.sd_layout.leftSpaceToView(self.titleLabel , 50).rightSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 16).autoHeightRatio(0);
        
    }
    
    
    
    
    
    self.titleLabel.text = VALIDATE_STRING(model.optionName);
    self.detailLabel.text = model.detail.length > 0 ? model.detail : @" ";
    
    
    
    
    [self setupAutoHeightWithBottomView:self.detailLabel bottomMargin:MARGIN_15];
}


@end
