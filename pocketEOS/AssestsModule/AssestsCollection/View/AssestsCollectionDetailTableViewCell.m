//
//  AssestsCollectionDetailTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/10/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AssestsCollectionDetailTableViewCell.h"

@interface AssestsCollectionDetailTableViewCell ()
@property(nonatomic , strong) BaseLabel *titleLabel;
@property(nonatomic , strong) BaseLabel1 *detailLabel;
@end

@implementation AssestsCollectionDetailTableViewCell

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (BaseLabel1 *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel1 alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _detailLabel;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.contentView, 12.5).heightIs(MARGIN_15).widthIs(150);
        
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).topSpaceToView(self.titleLabel, 6).widthIs(300).heightIs(13);
        
        [self.contentView addSubview:self.rightIconImageView];
        self.rightIconImageView.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).widthIs(24).heightIs(24).centerYEqualToView(self.contentView);
    }
    return self;
}


-(void)setModel:(CommonTransferModel *)model{
    self.titleLabel.text = model.from;
    self.detailLabel.text = model.resultStr;
    self.rightIconImageView.image = [UIImage imageNamed:@"circleWithRight_lightGray"];

    /**
     status :comleted , faild , handling
     */
    if ([model.status isEqualToString:@"comleted"]) {
        self.rightIconImageView.image = [UIImage imageNamed:@"circleTip_green"];
    }else if ([model.status isEqualToString:@"faild"]){
        self.rightIconImageView.image = [UIImage imageNamed:@"circleTip_red"];
    }else if( [model.status isEqualToString:@"handling"]){
        self.rightIconImageView.image = [UIImage imageNamed:@"circleTip_yellow"];
    }


}



@end
