//
//  PopUpWindow.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/4.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "PopUpWindow.h"
#import "Assest.h"
#import "AccountInfo.h"

@interface PopUpWindow ()<UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSArray *dataArray;
// tableView 底部的 view , 用来设置 半透明
@property(nonatomic, strong) UIView *bottomview;

@end

@implementation PopUpWindow


- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];//不显示多余的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (UIView *)bottomview{
    if (!_bottomview) {
        _bottomview = [[UIView alloc] init];
        _bottomview.backgroundColor = [UIColor blackColor];
        _bottomview.alpha = 0.5;
        _bottomview.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bottomview addGestureRecognizer:tap];
    }
    return _bottomview;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bottomview addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)updateViewWithArray:(NSArray *)arr title:(NSString *)title{
    [self addSubview:self.bottomview];
    self.bottomview.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.tableView, 0).rightSpaceToView(self, 0).heightIs(SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50 - (self.dataArray.count * 50));
    
    if (arr.count == 0) {
        return;
    }
    self.dataArray = arr;
    self.title = title;
    [self addSubview:self.tableView];
    _tableView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(self.dataArray.count * 50);
    
    [self.tableView reloadData];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_REUSEUDENTIFIER1];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEUDENTIFIER1];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.rightIconImgName = @"right_icon_blue";
    [cell.contentView addSubview:cell.rightIconImageView];
    cell.rightIconImageView.sd_layout.rightSpaceToView(cell.contentView, 20).widthIs(13).heightIs(10).centerYEqualToView(cell.contentView);
 
    
    if (self.type == PopUpWindowTypeAssest) {
        Assest *model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.assetName;
        if (model.selected) {
            cell.textLabel.textColor = HEXCOLOR(0x4D7BFE);
            cell.rightIconImageView.hidden = NO;
        }else{
            cell.textLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            cell.rightIconImageView.hidden = YES;
        }
    }else if(self.type == PopUpWindowTypeAccount){
        AccountInfo *model = self.dataArray[indexPath.row];
        if (model.selected) {
            cell.textLabel.textColor = HEXCOLOR(0x4D7BFE);
           cell.rightIconImageView.hidden = NO;
        }else{
            cell.textLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            cell.rightIconImageView.hidden = YES;
        }
        cell.textLabel.text = model.account_name;
        
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(popUpWindowdidSelectItem:)]) {
        [self.delegate popUpWindowdidSelectItem:model];
    }
    [self dismiss];
}
 
- (void)dismiss{
    if (!self.onBottomViewDidClick) {
        return;
    }
    self.onBottomViewDidClick();
}
@end
