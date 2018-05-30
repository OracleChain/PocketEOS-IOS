//
//  PopUpAssestWindow.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/7.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "PopUpAssestWindow.h"
#import "Assest.h"

@interface PopUpAssestWindow ()<UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSArray *dataArray;
// tableView 底部的 view , 用来设置 半透明
@property(nonatomic, strong) UIView *bottomview;
@end

@implementation PopUpAssestWindow
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 120 - 48 - TABBAR_HEIGHT))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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
        _bottomview = [[UIView alloc] initWithFrame:(CGRectMake(0, 50 * self.dataArray.count , SCREEN_WIDTH, self.height - (50 * self.dataArray.count)))];
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
    }
    return self;
}
- (void)updateViewWithArray:(NSArray *)arr title:(NSString *)title{
    if (arr.count == 0) {
        return;
    }
    self.dataArray = arr;
    self.title = title;
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    
    [self addSubview:self.bottomview];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CELL_REUSEUDENTIFIER1];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEUDENTIFIER1];
    }
    cell.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    Assest *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.assetName;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.title;
    label.frame = CGRectMake(15, 0, 100, 50);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Assest *model = self.dataArray[indexPath.row];
    NSLog(@"%@", model.assetName);
    
    NSLog(@"%@", self.dataArray[indexPath.row]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(popUpAssestWindowdidSelectItem:)]) {
        [self.delegate popUpAssestWindowdidSelectItem:model];
    }
    
}

- (void)dismiss{
    if (!self.onBottomViewDidClick) {
        return;
    }
    self.onBottomViewDidClick();
}

@end
