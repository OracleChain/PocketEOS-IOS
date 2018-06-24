//
//  BandwidthManageTableViewCell.m
//  pocketEOS
//
//  Created by 师巍巍 on 21/06/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BandwidthManageTableViewCell.h"

@interface BandwidthManageTableViewCell()
@property (weak, nonatomic) IBOutlet BaseLabel1 *TotalQuotaLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *QuotaApproveLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *useLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *avalibleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation BandwidthManageTableViewCell



-(void)setModel:(BandwidthManageCellModel *)model{
    self.titleLabel.text = model.title;
    self.TotalQuotaLabel.text = [NSString stringWithFormat:@"总配额：%@ ms", model.max];
    self.QuotaApproveLabel.text = [NSString stringWithFormat:@"配额抵押：%@", model.weight];
    
    if ([model.title isEqualToString:NSLocalizedString(@"cpu", nil)]) {
        self.useLabel.text = [NSString stringWithFormat:@"当前占用：%@ ms", model.used];
        self.avalibleLabel.text = [NSString stringWithFormat:@"当前可用：%@ ms", model.available];
        
    }else if ([model.title isEqualToString:NSLocalizedString(@"net", nil)]){
        self.useLabel.text = [NSString stringWithFormat:@"当前占用：%@ bytes", model.used];
        self.avalibleLabel.text = [NSString stringWithFormat:@"当前可用：%@ bytes", model.available];
    }
}

@end
