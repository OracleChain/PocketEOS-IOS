//
//  DiscoverBannerCollectionViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/1.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "DiscoverBannerCollectionViewCell.h"

@interface DiscoverBannerCollectionViewCell ()
@property (nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic , strong) BaseLabel *titleLabel;
@property(nonatomic , strong) UILabel *tagLabel;
@property(nonatomic , strong) BaseLabel1 *detailLabel;

@end

@implementation DiscoverBannerCollectionViewCell

- (UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.sd_cornerRadius = @6;
    }
    return _avatarImgView;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont systemFontOfSize:10];
        _tagLabel.textColor = HEXCOLOR(0xFFFFFF);
        _tagLabel.backgroundColor = HEXCOLOR(0x3CA8FF);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.sd_cornerRadius = @2;
    }
    return _tagLabel;
}

- (BaseLabel1 *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel1 alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _detailLabel;
}





- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}



-(void)setModel:(DappModel *)model{
    [self.contentView addSubview:self.avatarImgView];
    self.avatarImgView.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).heightIs(DISCOVER_CYCLESCROLLVIEW_HEIGHT);
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_10).topSpaceToView(self.avatarImgView, MARGIN_15).rightSpaceToView(self.contentView, MARGIN_15).heightIs(18);
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:10],
                                 NSForegroundColorAttributeName:HEXCOLOR(0xFFFFFF)
                                 };
    CGSize calculatedSize = [model.dappCategoryName boundingRectWithSize:CGSizeMake(100, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    [self.contentView addSubview:self.tagLabel];
    self.tagLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_10).topSpaceToView(self.titleLabel, 8).heightIs(13).widthIs(calculatedSize.width + 10);
    //    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [self.contentView addSubview:self.detailLabel];
    self.detailLabel.sd_layout.leftSpaceToView(self.tagLabel, 7).topEqualToView(self.tagLabel).heightIs(13).rightSpaceToView(self.contentView, MARGIN_20);
    
    
    
    [self.avatarImgView sd_setImageWithURL:String_To_URL(model.dappImage) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.titleLabel.text = model.dappName;
    self.tagLabel.text = model.dappCategoryName;
//    self.tagLabel.textColor = model.textColor;
//    self.tagLabel.backgroundColor = model.tagColor;

    
    self.detailLabel.text = model.dappIntro;
    
}


@end
