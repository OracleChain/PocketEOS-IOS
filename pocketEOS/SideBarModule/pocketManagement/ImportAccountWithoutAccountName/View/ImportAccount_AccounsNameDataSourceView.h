//
//  ImportAccount_AccounsNameDataSourceView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImportAccountModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ImportAccount_AccounsNameDataSourceViewDelegate <NSObject>


- (void)importAccount_AccounsNameDataSourceViewCloseBtnDidClick;
- (void)importAccount_AccounsNameDataSourceViewConfirmBtnDidClick;

- (void)importAccount_AccounsNameDataSourceViewTableViewCellDidClick:(ImportAccountModel *)model;
@end

@interface ImportAccount_AccounsNameDataSourceView : UIView
@property(nonatomic, weak) id<ImportAccount_AccounsNameDataSourceViewDelegate> delegate;


- (void)updateViewWithArray:(NSArray *)dataArray;

@property(nonatomic , strong) NSMutableArray *dataSourceArray;

@property(nonatomic , strong) UITableView *mainTableView;
@end

NS_ASSUME_NONNULL_END
