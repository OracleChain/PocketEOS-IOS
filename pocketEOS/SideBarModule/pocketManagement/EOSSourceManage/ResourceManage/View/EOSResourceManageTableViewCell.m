//
//  EOSResourceManageTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "EOSResourceManageTableViewCell.h"

@interface EOSResourceManageTableViewCell()
@property (weak, nonatomic) IBOutlet BaseLabel1 *TotalQuotaLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *QuotaApproveLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *useLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *avalibleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation EOSResourceManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(EOSResourceCellModel *)model{
    self.titleLabel.text = model.title;
    self.TotalQuotaLabel.text = [NSString stringWithFormat:@"总配额：%@ ms", model.max];
    self.QuotaApproveLabel.text = [NSString stringWithFormat:@"配额抵押：%@", model.weight];
    self.useLabel.text = [NSString stringWithFormat:@"当前占用：%@ ms", model.used];
    self.avalibleLabel.text = [NSString stringWithFormat:@"当前可用：%@ ms", model.available];
}

@end
