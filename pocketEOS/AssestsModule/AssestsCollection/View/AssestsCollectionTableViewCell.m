//
//  AssestsCollectionTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestsCollectionTableViewCell.h"

@interface AssestsCollectionTableViewCell ()
@property(nonatomic , strong) BaseLabel *titleLabel;
@property(nonatomic , strong) BaseLabel *detailLabel;
@end

@implementation AssestsCollectionTableViewCell

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (BaseLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = [UIFont systemFontOfSize:15];
    }
    return _detailLabel;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(150);
        
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.sd_layout.leftSpaceToView(self.titleLabel, MARGIN_20).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.rightIconImageView, 12);
        
        [self.contentView addSubview:self.rightIconImageView];
        self.rightIconImageView.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).widthIs(16).heightIs(16).centerYEqualToView(self.contentView);
    }
    return self;
}


-(void)setModel:(TokenInfo *)model{
    self.titleLabel.text = model.account_name;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@", model.balance, model.token_symbol];
    
    if (model.balance.doubleValue == 0) {
        self.rightIconImageView.image = [UIImage imageNamed:@"circleWithRight_lightGray"];
    }else{
        
        if (model.isSelected) {
            self.rightIconImageView.image = [UIImage imageNamed:@"circleWithRight_blue"];
        }else{
            self.rightIconImageView.image = [UIImage imageNamed:@"circleWithoutRight_gray"];
        }
        
    }
}

@end
