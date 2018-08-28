//
//  RedPacketRecordsTableViewCell.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/27.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RedPacketRecord.h"

@interface RedPacketRecordsTableViewCell : BaseTableViewCell

@property(nonatomic , strong) RedPacketRecord *model;

@end
