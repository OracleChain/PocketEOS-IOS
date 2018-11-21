
//
//  ImportAccount_AccounsNameDataSourceView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/16.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccount_AccounsNameDataSourceView.h"
#import "ImportAccount_AccounsNameDataSourceViewTableViewCell.h"

@interface ImportAccount_AccounsNameDataSourceView ()< UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic , strong) UIView *topBaseView;
@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UIButton *closeBtn;
@property(nonatomic , strong) UIView *contentBaseView;

@property(nonatomic , strong) BaseSlimLineView *bottomLine;
@property(nonatomic , strong) UIButton *confirmBtn;
@end

@implementation ImportAccount_AccounsNameDataSourceView

- (UIView *)topBaseView{
    if (!_topBaseView) {
        _topBaseView = [[UIView alloc] init];
        _topBaseView.userInteractionEnabled = YES;
        _topBaseView.backgroundColor = [UIColor blackColor];
        _topBaseView.alpha = 0.5;
        
    }
    return _topBaseView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"请选择您想要导入的账号", nil);
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"dapp_close"] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}


- (UIView *)contentBaseView{
    if (!_contentBaseView) {
        _contentBaseView = [[UIView alloc] init];
        _contentBaseView.backgroundColor = [UIColor whiteColor];
    }
    return _contentBaseView;
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        _mainTableView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            _mainTableView.separatorColor = HEX_RGB(0xEEEEEE);
            
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            _mainTableView.separatorColor = HEX_RGB_Alpha(0xFFFFFF, 0.1);
        }
        
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _mainTableView.scrollsToTop = YES;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}


- (BaseSlimLineView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[BaseSlimLineView alloc] init];
        _bottomLine.backgroundColor = HEXCOLOR(0xE6E6E6);
    }
    return _bottomLine;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:NSLocalizedString(@"确认", nil) forState:(UIControlStateNormal)];
        [_confirmBtn setFont:[UIFont systemFontOfSize:15]];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_confirmBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:(UIControlStateNormal)];
        [_confirmBtn setBackgroundColor:HEXCOLOR(0x4D7BFE)];
    }
    return _confirmBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnClick)];
        tap.delegate = self;
        [self.topBaseView addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateViewWithArray:(NSArray *)dataArray{

    
    self.dataSourceArray = [NSMutableArray arrayWithArray:dataArray];
    
    CGFloat contentBaseViewHeight = NAVIGATIONBAR_HEIGHT + (50 * dataArray.count) + 85;
    
    [self addSubview:self.contentBaseView];
    
    self.contentBaseView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0).heightIs(contentBaseViewHeight);
    
    [self addSubview:self.topBaseView];
    self.topBaseView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self.contentBaseView, 0);
    
    [self.contentBaseView addSubview:self.titleLabel];
    self.titleLabel.sd_layout.centerXEqualToView(self.contentBaseView).topSpaceToView(self.contentBaseView, MARGIN_20).leftSpaceToView(self.contentBaseView, 60).rightSpaceToView(self.contentBaseView, 60);
    
    [self.contentBaseView addSubview:self.closeBtn];
    self.closeBtn.sd_layout.rightSpaceToView(self.contentBaseView, 26).centerYEqualToView(self.titleLabel).widthIs(12).heightIs(12);
    
    [self.contentBaseView addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.contentBaseView, 0).topSpaceToView(self.titleLabel, MARGIN_20).rightSpaceToView(self.contentBaseView, 0).heightIs(dataArray.count * 50);
    
    [self.contentBaseView addSubview:self.bottomLine];
    
    self.bottomLine.sd_layout.leftSpaceToView(self.contentBaseView, 0).bottomSpaceToView(self.contentBaseView, 85).rightSpaceToView(self.contentBaseView, 0).heightIs(DEFAULT_LINE_HEIGHT);
    
    [self.contentBaseView addSubview:self.confirmBtn];
    
    self.confirmBtn.sd_layout.leftSpaceToView(self.contentBaseView, MARGIN_20).rightSpaceToView(self.contentBaseView, MARGIN_20).topSpaceToView(self.bottomLine, MARGIN_20).bottomSpaceToView(self.contentBaseView, MARGIN_20);
    
    
    [self.mainTableView reloadData];
//
//    if (self.dataSourceArray.count==1) {
//        self.confirmBtn.lee_theme
//        .LeeConfigBackgroundColor(@"confirmButtonNormalStateBackgroundColor");
//        self.hasViewAllAction = YES;
//
//    }else{
//        self.confirmBtn.lee_theme
//        .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xD8D8D8))
//        .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0xA3A3A3));
//
//    }
//
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImportAccount_AccounsNameDataSourceViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[ImportAccount_AccounsNameDataSourceViewTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    ImportAccountModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ImportAccountModel *model = self.dataSourceArray[indexPath.row];
    // 账号状态 0 ：未导入 1 ： 已经导入 2 ：导入失败 3 :本地存在 4:权限错误
    if (model.status == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(importAccount_AccounsNameDataSourceViewTableViewCellDidClick:)]) {
            [self.delegate importAccount_AccounsNameDataSourceViewTableViewCellDidClick:model];;
        }
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



- (void)closeBtnClick{
    
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccount_AccounsNameDataSourceViewCloseBtnDidClick)]) {
        [self.delegate importAccount_AccounsNameDataSourceViewCloseBtnDidClick];
    }
}

- (void)confirmBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccount_AccounsNameDataSourceViewConfirmBtnDidClick)]) {
        [self.delegate importAccount_AccounsNameDataSourceViewConfirmBtnDidClick];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.contentBaseView]) {
        return NO;
    }else{
        return YES;
    }
}


@end
